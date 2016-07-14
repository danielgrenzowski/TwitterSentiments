import UIKit

import AlchemyLanguageV1

class DetailViewController: UIViewController {

  // UI
  @IBOutlet weak var entityNameLabel: UILabel!
  @IBOutlet weak var entityTextLabel: UILabel!
  @IBOutlet weak var entityTypeLabel: UILabel!
  @IBOutlet weak var sentimentScoreLabel: UILabel!
  @IBOutlet weak var sentimentPolarityLabel: UILabel!
  @IBOutlet weak var entityRelevanceLabel: UILabel!
  
  var entity: Entity?
  
  // MARK - NSObject
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.configureView()
  }

  // MARK - UI
  
  func configureView() {
    
    configureNavigationItem(self.navigationItem)
    
    if let myEntity = self.entity {
      
      configureLabel(entityTypeLabel, withText: myEntity.type)
      if let score = myEntity.sentiment?.score {
        configureLabel(sentimentScoreLabel, withText: String(score))
      }
      configureLabel(sentimentPolarityLabel, withText: myEntity.sentiment?.type)
      if let relevance = myEntity.relevance {
        configureLabel(entityRelevanceLabel, withText: String(relevance))
      }
      configureLabel(entityNameLabel, withText: myEntity.text)
      configureLabel(entityTextLabel, withText: myEntity.disambiguated?.name)
    }
  }
  
  func configureNavigationItem(navigationItem:UINavigationItem) {
    if let myEntity = self.entity {
      navigationItem.title = myEntity.text
    }
  }
  
  func configureLabel(label: UILabel, withText text:String?) -> Void {
    
    if let myText = text {
      label.text = myText
    } else {
      label.text = "(Not found)"
    }
  }
}

