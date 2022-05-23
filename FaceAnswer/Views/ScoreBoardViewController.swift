//
//  ScoreBoardViewController.swift
//  FaceAnswer
//


import UIKit
import CoreData

class ScoreBoardViewController: UIViewController {

    @IBOutlet weak var scoreBoardTableView: UITableView!
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var items:[User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Score Board"
        fetchUsers()
    }
    
    // fetces the data from Core Data to display in the tableview
    func fetchUsers() {
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let sort  = NSSortDescriptor(key: "score", ascending: false)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.scoreBoardTableView.reloadData()
            }
            
        } catch {
            
        }
    }

}

// extension for handling table view
extension ScoreBoardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreBoardCell", for: indexPath) as! ScoreBoardTableViewCell
        
        // Get user from array and set the label
        let user = self.items![indexPath.row]
        
        cell.userNameText.text = user.userName
        cell.scoreText.text = "\(user.score)"
        
        return cell
    }
    
    
}
