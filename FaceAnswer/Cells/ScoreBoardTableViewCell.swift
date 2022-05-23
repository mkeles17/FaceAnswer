//
//  ScoreBoardTableViewCell.swift
//  FaceAnswer
//


import UIKit

class ScoreBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
