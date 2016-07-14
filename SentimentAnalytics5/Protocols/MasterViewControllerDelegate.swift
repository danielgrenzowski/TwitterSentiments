import Foundation

protocol MasterViewControllerDelegate {
  
  func masterViewControllerDidLogOutUser(controller: MasterViewController, withUserId userID:String) -> Void
}