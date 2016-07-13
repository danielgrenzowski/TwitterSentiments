import Foundation
import UIKit
import TwitterKit

class InitialViewController : UIViewController {
  
  var loginViewController : LoginViewController? = nil
  var masterViewController : MasterViewController? = nil
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    startLoginFlows()
  }
  
  func startLoginFlows() -> Void {
    
    if currentUserIsLoggedIn() {
      showLoggedInView()
    } else {
      showLogInView()
    }
  }

  func currentUserIsLoggedIn() -> Bool {
    
    let store = Twitter.sharedInstance().sessionStore
    
    if (store.session()?.userID != nil) {
      return true;
    } else {
      return false
    }
  }
  
  func showLoggedInView() -> Void {
    
    if (masterViewController == nil) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      if let masterViewController = storyboard.instantiateViewControllerWithIdentifier("MasterViewController") as? MasterViewController {
        
        masterViewController.delegate = self
        self.navigationController?.pushViewController(masterViewController, animated: false)
      }
    }
  }
  
  func showLogInView() -> Void {
    
    if (loginViewController == nil) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      if let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
        
        loginViewController.delegate = self
        self.navigationController?.pushViewController(loginViewController, animated: false)
      }
    }
  }
}

// MARK - LoginViewControllerDelegate

extension InitialViewController : LoginViewControllerDelegate {
  
  func loginViewControllerDidLogUserIn(controller: LoginViewController, withUserId userID:String) -> Void {
    
    self.navigationController?.popToRootViewControllerAnimated(false)
  }
}

// MARK - MasterViewControllerDelegate

extension InitialViewController : MasterViewControllerDelegate {
  func masterViewControllerDidLogOutUser(controller: MasterViewController, withUserId userID:String) -> Void {
    
    self.navigationController?.popToRootViewControllerAnimated(false)
  }
}
