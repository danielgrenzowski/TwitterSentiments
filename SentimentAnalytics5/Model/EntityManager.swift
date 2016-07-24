import Foundation

import AlchemyLanguageV1

class EntityManager {
  
  var entities : [Entity] = []
  
  // Singleton constant and private initializer
  static let sharedInstance = EntityManager()
  private init() {
  }
  
}