import Foundation
import AlchemyLanguageV1

class EntityManager : NSObject {
  
  var entities : [Entity]
  
  init(entities: [Entity]) {
    self.entities = entities
  }

}