//
//  GameEndPageViewController.swift
//  FaceAnswer
//


import UIKit

class GameEndPageViewController: UIViewController {
    
    var user: String?
    var score: Int?

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // displays the userName and the score of the user
        // also saves the User, with userName and score, to the CoreData database
        if let userName = user, let userScore = score {
            usernameLabel.text = userName
            scoreLabel.text = "\(userScore) / 10"
            
            let newUser = User(context: self.context)
            newUser.userName = userName
            newUser.score = Int64(userScore)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
        
    }

}
