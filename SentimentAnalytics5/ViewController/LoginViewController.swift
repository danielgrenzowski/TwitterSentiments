import Foundation
import UIKit
import TwitterKit

class LoginViewController : UIViewController {
  
  var delegate : LoginViewControllerDelegate?

  override func viewDidLoad() {
    
    super.viewDidLoad()
    configureUI()
  }
  
  func configureUI() -> Void {
    
    // Configure Twitter Login button
    let logInButton = TWTRLogInButton(logInCompletion: { session, error in
      if (session != nil) {
        self.delegate?.loginViewControllerDidLogUserIn(self, withUserId: session!.userID)
      } else {
        print("error: \(error!.localizedDescription)");
      }
    })
    logInButton.center = self.view.center
    self.view.addSubview(logInButton)
    
    // Hide Navbar back button
    self.navigationItem.hidesBackButton = true
  }
}
