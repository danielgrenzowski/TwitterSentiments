import Foundation

import UIKit
import TwitterKit

class LoginViewController : UIViewController {
  
  var delegate : LoginViewControllerDelegate?

  // Mark - NSObject
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK - UI
  
  func configureUI() -> Void {
    
    addTwitterLoginButtonToView(self.view)
    configureNavigationItem(self.navigationItem)
  }
  
  func configureNavigationItem(navigationItem:UINavigationItem) {
    
    navigationItem.hidesBackButton = true
  }
  
  func addTwitterLoginButtonToView(view: UIView) {
    
    // Configure Twitter login button
    let logInButton = TWTRLogInButton(logInCompletion: { session, error in
      if (session != nil) {
        self.delegate?.loginViewControllerDidLogUserIn(self, withUserId: session!.userID)
      } else {
        print("error: \(error!.localizedDescription)");
      }
    })
    logInButton.center = view.center
    view.addSubview(logInButton)
  }
}
