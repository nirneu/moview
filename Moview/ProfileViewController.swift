//
//  ProfileViewController.swift
//  Moview
//
//  Created by admin on 18/07/2021.
//

import UIKit
import Firebase
import Kingfisher

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    
    @IBAction func logoutClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch _ as NSError {
          displayAlert(message: "There was an error while saving your user, please try again later")
        }
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
        self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Model.instance.getAllUsers { users in
            let user = Model.instance.getUser(byId: Auth.auth().currentUser!.uid)
            self.fullNameText.text = user?.fullName
            self.emailText.text = Auth.auth().currentUser!.email
            self.profileImage.kf.setImage(with: URL(string: (user?.imageUrl)!), placeholder: UIImage(named: "user_avatar"))
        }
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
