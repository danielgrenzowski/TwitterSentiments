import UIKit
import AlchemyLanguageV1

class DetailViewController: UIViewController {


  @IBOutlet weak var entityNameLabel: UILabel!
  @IBOutlet weak var entityTextLabel: UILabel!
  @IBOutlet weak var entityTypeLabel: UILabel!
  @IBOutlet weak var sentimentScoreLabel: UILabel!
  @IBOutlet weak var sentimentPolarityLabel: UILabel!
  @IBOutlet weak var entityRelevanceLabel: UILabel!
  
  var entity: Entity?

  func configureView() {
    
    // Update the user interface for the detail item.
    if let myEntity = self.entity {
      
      if let myEntityName = myEntity.disambiguated?.name {
        configureLabel(entityNameLabel, withText: myEntityName)
      }
      
      if let myEntityType = myEntity.type {
        configureLabel(entityTypeLabel, withText: myEntityType)
      }
      
      if let myEntitySentimentScore = myEntity.sentiment?.score {
          configureLabel(sentimentScoreLabel, withText: String(myEntitySentimentScore))
      }
      
      if let myEntitySentimentPolarity = myEntity.sentiment?.type {
          configureLabel(sentimentPolarityLabel, withText: myEntitySentimentPolarity)
      }

      if let myEntityRelevance = myEntity.relevance {
        configureLabel(entityRelevanceLabel, withText: String(myEntityRelevance))

      }
      if let myEntityText = myEntity.text {
        configureLabel(entityTextLabel, withText: String(myEntityText))
      }
      
      print(myEntity)

    }
    
  }

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    entityTextLabel.numberOfLines = 0
    self.configureView()
  }
  
  func configureLabel(label: UILabel, withText text:String) -> Void {
    label.text = text
  }
}

