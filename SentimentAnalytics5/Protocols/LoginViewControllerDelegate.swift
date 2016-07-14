import Foundation

protocol LoginViewControllerDelegate {
  
  func loginViewControllerDidLogUserIn(controller: LoginViewController, withUserId userID:String) -> Void
}