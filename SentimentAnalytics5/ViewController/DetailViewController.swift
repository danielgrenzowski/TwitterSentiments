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
      
      if let myEntityName = myEntity.disambiguated?.name {
        configureLabel(entityNameLabel, withText: myEntityName)
      } else {
        configureLabel(entityNameLabel, withText: "No name found for selected Entity")
      }
      
      if let myEntityType = myEntity.type {
        configureLabel(entityTypeLabel, withText: myEntityType)
      } else {
        configureLabel(entityTypeLabel, withText: "No type found for selected Entity")
      }
      
      if let myEntitySentimentScore = myEntity.sentiment?.score {
          configureLabel(sentimentScoreLabel, withText: String(myEntitySentimentScore))
      } else {
        configureLabel(sentimentScoreLabel, withText: "No score found for selected Entity")
      }
      
      if let myEntitySentimentPolarity = myEntity.sentiment?.type {
          configureLabel(sentimentPolarityLabel, withText: myEntitySentimentPolarity)
      } else {
        configureLabel(sentimentPolarityLabel, withText: "No polarity found for selected Entity")
      }

      if let myEntityRelevance = myEntity.relevance {
        configureLabel(entityRelevanceLabel, withText: String(myEntityRelevance))
      } else {
        configureLabel(entityRelevanceLabel, withText: "No relevance found for selected Entity")
      }
      if let myEntityText = myEntity.text {
        configureLabel(entityTextLabel, withText: String(myEntityText))
      } else {
        configureLabel(entityTextLabel, withText: "No text found for selected Entity")
      }
      print(myEntity)
    }
  }
  
  func configureNavigationItem(navigationItem:UINavigationItem) {
    if let myEntity = self.entity {
      navigationItem.title = myEntity.text
    }
  }
  
  func configureLabel(label: UILabel, withText text:String) -> Void {
    label.text = text
  }
}

