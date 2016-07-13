import UIKit

import TwitterKit

class MasterViewController: UITableViewController {

  // UI
  var detailViewController: DetailViewController? = nil
  let searchController : UISearchController = UISearchController(searchResultsController: nil)
  var indicator = UIActivityIndicatorView()

  // Models
  let tweetManager : TweetManager = TweetManager(tweets: []);
  let watson : Watson = Watson()
  let entityManager : EntityManager = EntityManager(entities: [])
  
  // Delegate
  var delegate : MasterViewControllerDelegate?


  // MARK - NSObject
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    configureUI()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.tweetManagerDidFetchTweets(_:)), name:"TweetManagerDidFetchTweets", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.watsonDidFetchEntities(_:)), name:"WatsonDidFetchEntities", object: nil)
  }
  
  // MARK - UI
  
  func configureUI() -> Void {
    
    // Hide Navbar back button
    self.navigationItem.hidesBackButton = true
    
    configureSearchController()
    configureActivityIndicator()
  }
  
  func configureSearchController() -> Void {
    
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    
    searchController.searchBar.scopeButtonTitles = ["All", "Entities"]
    searchController.searchBar.delegate = self
  }
  
  // MARK - Activity Indicator

  
  func configureActivityIndicator() {
    indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    indicator.center = self.view.center
    self.view.addSubview(indicator)
  }
  
  func turnOnIndicator() {
    indicator.startAnimating()
    indicator.backgroundColor = UIColor.whiteColor()
  }
  
  func turnOffIndicator() {
    indicator.stopAnimating()
    indicator.hidesWhenStopped = true
  }
  
  // MARK - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "showEntityDetail" {
      
        if let indexPath = self.tableView.indexPathForSelectedRow {
          
          let entity = entityManager.entities[indexPath.row]
          let controller = segue.destinationViewController as! DetailViewController
          controller.entity = entity
        }
    }
  }

  // MARK: - Table View

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return entityManager.entities.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

    let entity = entityManager.entities[indexPath.row]
    cell.textLabel?.text = entity.text
    cell.detailTextLabel?.text = "Count: " + String(entity.count!)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("showEntityDetail", sender: self)
  }
  
  // MARK: Observer
  
  func tweetManagerDidFetchTweets(notification: NSNotification) -> Void {
    
    let tweets = tweetManager.tweets
    watson.fetchWatsonResponsesFromTweets(tweets)
  }
  
  func watsonDidFetchEntities(notification: NSNotification) -> Void {
    
    let entities = watson.entities
    entityManager.entities = entities
    // TO DO - Combine similar entities within entityManager before displaying the output

    tableView.reloadData()
    turnOffIndicator()
  }
  
  func entityManagerDidFetchEntities(notification: NSNotification) -> Void {
    tableView.reloadData()
    turnOffIndicator()
  }

  // MARK: Helpers
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
        
    if (scope == "Entities" || scope == "All") {
      if (!searchText.isEmpty) {
        turnOnIndicator()
        tweetManager.fetchDataFromTwitter(withSearchText: searchText)
      }
    }

    
  }
  
  // MARK: Logout button
  
  @IBAction func userDidTapLogoutButton(sender: AnyObject) {
    
    logOutCurrentUser()
  }
  
  func logOutCurrentUser() -> Void {
    
    let store = Twitter.sharedInstance().sessionStore
    
    if let userID = store.session()?.userID {
      store.logOutUserID(userID)
      self.delegate?.masterViewControllerDidLogOutUser(self, withUserId: userID)
    }
  }
}

// MARK: UISearchResultsUpdating delegate methods

extension MasterViewController: UISearchResultsUpdating {
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {


  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)  }
}

// MARK: UISearchBarDelegate delegate methods

extension MasterViewController: UISearchBarDelegate {
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    
  }
}



