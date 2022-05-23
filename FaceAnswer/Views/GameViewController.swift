//
//  GameViewController.swift
//  FaceAnswer
//


import UIKit
import AVFoundation
import Vision

class GameViewController: UIViewController {

    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var faceLayers: [CAShapeLayer] = []
    
    var player: String?
    
    private var currentQuestion: Int = 0
    private var questionsDataSource = QuestionsDataSource()
    private lazy var gameQuestions: [Question] = questionsDataSource.getRandomQuizQuestions()
    
    private var selectedAnswer = "-"
    
    private var score = 0
    
    private let winSoundID: SystemSoundID = 1116
    private let loseSoundID: SystemSoundID = 1106
    private let noAnswerSoundID: SystemSoundID = 1016
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerALabel: UITextView!
    @IBOutlet weak var answerBLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.cameraView.frame
        previewLayer.position = CGPoint(x: 180, y: 272.5)
        //y: self.cameraView.center.y - (self.cameraView.frame.height / 2)
        //x: self.cameraView.center.x - (self.cameraView.frame.width / 2)
        self.previewLayer.bounds = cameraView.frame
        configureUI(question: gameQuestions.first!)
    }
    
    // sets up the front camera
    private func setupCamera() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        if let device = deviceDiscoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: device){
                if captureSession.canAddInput(deviceInput){
                    captureSession.addInput(deviceInput)
                    setupPreview()
                }
            }
        }
    }
    
    // adds the view obtained from the camera to the cameraView layer in the correct position
    private func setupPreview() {
        self.previewLayer.videoGravity = .resizeAspectFill
        self.cameraView.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.cameraView.frame
        previewLayer.position = CGPoint(x: 180, y: 272.5)
        self.previewLayer.bounds = cameraView.frame
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        let videoConnection = self.videoDataOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
    }
    
    // configures the UI for the current question
    private func configureUI(question: Question) {
        self.selectedAnswer = "-"
        self.questionLabel.text = "\(currentQuestion+1)) \(question.questionBody)"
        self.answerALabel.text = question.answers[0].text
        self.answerALabel.textColor = UIColor.black
        self.answerBLabel.text = question.answers[1].text
        self.answerBLabel.textColor = UIColor.black
        
        // timer for user to decide on and give an answer
        let t1 = Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ [weak self] timer in
            self?.checkAnswer(question: question)
            timer.invalidate()
        }
        RunLoop.current.add(t1, forMode: .common)
        
    }
    
    // checks if the user has given the correct answer, the wrong answer or no answer at all
    // if the user has given the correct answer increments score by one
    // in each case plays the corresponding sound
    func checkAnswer(question: Question) {
        if selectedAnswer == "A" {
            if question.answers[0].correct {
                score += 1
                AudioServicesPlaySystemSound(winSoundID)
            }else{
                AudioServicesPlaySystemSound(loseSoundID)
            }
        }else if selectedAnswer == "B" {
            if question.answers[1].correct {
                score += 1
                AudioServicesPlaySystemSound(winSoundID)
            }else{
                AudioServicesPlaySystemSound(loseSoundID)
            }
        }else {
            AudioServicesPlaySystemSound(noAnswerSoundID)
        }
        
        // shows the user the correct answer with green and the wrong answer with red
        if question.answers[0].correct {
            self.answerALabel.textColor = UIColor.green
            self.answerBLabel.textColor = UIColor.red
        }else {
            self.answerALabel.textColor = UIColor.red
            self.answerBLabel.textColor = UIColor.green
        }
    
        // timer for user to see the correct answer before the next question
        let t2 = Timer.scheduledTimer(withTimeInterval: 2, repeats: false){ [weak self] timer in
            self?.nextRound()
            timer.invalidate()
        }
        RunLoop.current.add(t2, forMode: .common)
        
    }
    
    // checks if the game has ended, otherwise continues with the next round
    private func nextRound() {
        if currentQuestion == 9 {
            endGame()
        }else{
            currentQuestion += 1
            configureUI(question: gameQuestions[currentQuestion])
        }
    }
    
    // when the game has ended, performs the segue action
    private func endGame(){
        print(score)
        self.performSegue(withIdentifier: "endGame", sender: nil)
    }
    

    
    

    // passes userName and Score to GameEndPageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "endGame"{
            let gameEndPageViewController = segue.destination as! GameEndPageViewController
            gameEndPageViewController.user = self.player
            gameEndPageViewController.score = self.score
        }
    }
    

}

// necessary extension for face detection
extension GameViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // main function for continuously detection face features of the user
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                self.faceLayers.forEach({ drawing in drawing.removeFromSuperlayer() })

                if let observations = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionObservations(observations: observations)
                }
            }
        })

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .leftMirrored, options: [:])

        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // handles the detection of the face of the user
    private func handleFaceDetectionObservations(observations: [VNFaceObservation]) {
        for observation in observations {
            let faceRectConverted = self.previewLayer.layerRectConverted(fromMetadataOutputRect: observation.boundingBox)
            let faceRectanglePath = CGPath(rect: faceRectConverted, transform: nil)
            
            let faceLayer = CAShapeLayer()
            faceLayer.path = faceRectanglePath
            faceLayer.fillColor = UIColor.clear.cgColor
            faceLayer.strokeColor = UIColor.yellow.cgColor
            
            self.faceLayers.append(faceLayer)
            self.cameraView.layer.addSublayer(faceLayer)
            
            // decides if the user rolled his/her head to left or right and marks the answer accordingly
            let roll = observation.roll!.doubleValue
            if roll < 1.2 {
                selectedAnswer = "B"
            }else if roll > 1.6 {
                selectedAnswer = "A"
            }
                
            //FACE LANDMARKS
            if let landmarks = observation.landmarks {
                if let leftEye = landmarks.leftEye {
                    self.handleLandmark(leftEye, faceBoundingBox: faceRectConverted)
                }
                if let leftEyebrow = landmarks.leftEyebrow {
                    self.handleLandmark(leftEyebrow, faceBoundingBox: faceRectConverted)
                }
                if let rightEye = landmarks.rightEye {
                    self.handleLandmark(rightEye, faceBoundingBox: faceRectConverted)
                }
                if let rightEyebrow = landmarks.rightEyebrow {
                    self.handleLandmark(rightEyebrow, faceBoundingBox: faceRectConverted)
                }

                if let nose = landmarks.nose {
                    self.handleLandmark(nose, faceBoundingBox: faceRectConverted)
                }

                if let outerLips = landmarks.outerLips {
                    self.handleLandmark(outerLips, faceBoundingBox: faceRectConverted)
                }
                if let innerLips = landmarks.innerLips {
                    self.handleLandmark(innerLips, faceBoundingBox: faceRectConverted)
                }
            }
        }
    }
    
    // creates the marks around the given part e.g. nose, eye, lips
    private func handleLandmark(_ eye: VNFaceLandmarkRegion2D, faceBoundingBox: CGRect) {
        let landmarkPath = CGMutablePath()
        let landmarkPathPoints = eye.normalizedPoints
            .map({ eyePoint in
                CGPoint(
                    x: eyePoint.y * faceBoundingBox.height + faceBoundingBox.origin.x,
                    y: eyePoint.x * faceBoundingBox.width + faceBoundingBox.origin.y)
            })
        landmarkPath.addLines(between: landmarkPathPoints)
        landmarkPath.closeSubpath()
        let landmarkLayer = CAShapeLayer()
        landmarkLayer.path = landmarkPath
        landmarkLayer.fillColor = UIColor.clear.cgColor
        landmarkLayer.strokeColor = UIColor.green.cgColor

        self.faceLayers.append(landmarkLayer)
        self.cameraView.layer.addSublayer(landmarkLayer)
    }
}
