import Foundation

import TwitterKit

class TweetManager : NSObject {
  
  var tweets : [TWTRTweet]

  // MARK - NSObject
  
  init(tweets:[TWTRTweet]) {
    self.tweets = tweets
  }
  
  // Mark - Convenience methods
  
  func fetchTweetsFromSearchText(searchText: String) -> Void {
    
    let completionBlock:(NSURLResponse?, NSData?, NSError?) -> Void = { (response, data, connectionError) -> Void in
      
      if connectionError != nil {
        print("Error: \(connectionError)")
      }
      
      if let returnedData = data {
        do {
          let json = try NSJSONSerialization.JSONObjectWithData(returnedData, options: [])
          if let dictionary = json as? [String : AnyObject] {
            if let tweetArray = dictionary["statuses"] as? [AnyObject] {
              
              self.tweets = TWTRTweet.tweetsWithJSONArray(tweetArray) as! [TWTRTweet]
              
              // update client
              NSNotificationCenter.defaultCenter().postNotificationName("TweetManagerDidFetchTweets", object: nil)
            }
          }
        } catch let jsonError as NSError {
          print("json error: \(jsonError.localizedDescription)")
        }
      } else {
        print("No data was returned by request")
      }
    }
    
    fetchTweetsFromTwitterSearchAPIWithSearchText(searchText, completionBlock: completionBlock)
  }
  
  // MARK - Twitter API
  
  func fetchTweetsFromTwitterSearchAPIWithSearchText(searchText: String, completionBlock:(NSURLResponse?, NSData?, NSError?) -> Void) -> Void {
    
    if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
      
      let client = TWTRAPIClient(userID: userID)
      let encodedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!

      let searchEndpoint = "https://api.twitter.com/1.1/search/tweets.json?q=\(encodedSearchText)&lang=en&result_type=recent"
      
      let params = ["id": "20"]
      var clientError : NSError?
      
      let myRequest = client.URLRequestWithMethod("GET", URL: searchEndpoint, parameters: params, error: &clientError)
      
      client.sendTwitterRequest(myRequest, completion: completionBlock)
    } else {
      print("User ID not found! Check that an active session has been created through a user login.")
    }
  }
}
