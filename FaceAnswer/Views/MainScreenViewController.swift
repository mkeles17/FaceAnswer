//
//  MainScreenViewController.swift
//  FaceAnswer
//


import UIKit

class MainScreenViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.delegate = self
    }
    

    
    // passes userName to GameViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "startGame"{
            let gameViewController = segue.destination as! GameViewController
            gameViewController.player = userName
        }
    }
    
    // when start button is clicked, this method checks for userName contraints, pops up an alert if there is a violation, otherwise continues with segue action
    @IBAction func startButtonClicked(_ sender: Any) {
        userName = userNameTextField.text ?? ""
        if userName.count < 2 || userName.count > 15 {
            let alert = UIAlertController(title: "Try Again!", message: "Username must be between 2-15 characters.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if userName.containsEmoji {
            let alert = UIAlertController(title: "Try Again!", message: "Username cannot contain any emojis.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "startGame", sender: nil)
        }
                
    }
    
    // allows user to hide keyboard after done typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// necessary extensions for Emoji check
extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first? .properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
}
