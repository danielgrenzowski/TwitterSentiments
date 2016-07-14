import Foundation

import AlchemyLanguageV1
import TwitterKit

class Watson: NSObject {
  
  let apiKey = "a70edc2dc0ce25efd443de3e3e1e912b486919ee"
  var entities = [Entity]()
  
  func fetchWatsonResponsesFromTweets(tweetArray:[TWTRTweet]) -> Void {
    
    entities = []
    
    for tweet in tweetArray {
      
      let text = tweet.text;
    
      // Write tweet to a local text file (required for AlchemyLanguage API call
      let tempFile = "tempFile.txt"
      let fileName = getDocumentsDirectory().stringByAppendingPathComponent(tempFile)
      do {
        try text.writeToFile(fileName, atomically: true, encoding: NSUTF8StringEncoding)
      } catch {
        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        print("Error writing Tweet to file")
      }
      
      let url = NSURL(fileURLWithPath: fileName)
      let alchemyLanguage = AlchemyLanguage(apiKey: apiKey)
      alchemyLanguage.getRankedNamedEntities(forText:url, success: { (results) in
        if let myEntities = results.entitites {
          for myEntity in myEntities {
            
            self.entities.append(myEntity)
          }
        } else {
          // no entities extracted from tweet
        }
        
        // update client
        NSNotificationCenter.defaultCenter().postNotificationName("WatsonDidFetchEntities", object: nil)
      })
    }
  }
  
  // MARK - Helpers
  
  func getDocumentsDirectory() -> NSString {
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }
}
  
  

