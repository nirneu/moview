//
//  ProfileMenuTableViewController.swift
//  Moview
//
//  Created by admin on 18/07/2021.
//

import UIKit

enum MenuActionSegue: String {
    case editName = "editName", changePass = "changePass", toMyReviewsSegue = "toMyReviewsSegue"
}

class ProfileMenuTableViewController: UITableViewController {
    weak var delegate : ProfileTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
        var action: MenuActionSegue = MenuActionSegue.editName
        
        // edit name, email
        if (indexPath.section == 0 && indexPath.row == 0) {
            action = MenuActionSegue.editName
        }
        // change password
        else if (indexPath.section == 0 && indexPath.row == 1) {
            action = MenuActionSegue.changePass
        }
        // my reviews
        else if (indexPath.section == 1 && indexPath.row == 0) {
            action = MenuActionSegue.toMyReviewsSegue
        }
        
        if let delegate = delegate {
            delegate.cellTapped(segue: action)
            
        }
      }
}

protocol ProfileTableViewControllerDelegate : AnyObject {
    func cellTapped(segue: MenuActionSegue)
}
