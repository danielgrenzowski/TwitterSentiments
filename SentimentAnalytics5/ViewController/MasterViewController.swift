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
    
    configureSearchController(self.searchController, tableView:self.tableView)
    definesPresentationContext = true
    configureActivityIndicatorForView(self.view)
    configureNavigationItem(self.navigationItem)
  }
  
  func configureNavigationItem(navigationItem:UINavigationItem) {
    
    navigationItem.title = "Entities"
    navigationItem.hidesBackButton = true
  }
  
  func configureSearchController(searchController:UISearchController, tableView:UITableView) -> Void {
    
    searchController.dimsBackgroundDuringPresentation = false
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchBar.scopeButtonTitles = ["All", "Entities"]
    searchController.searchBar.delegate = self
  }
  
  // MARK - Activity Indicator

  func configureActivityIndicatorForView(view:UIView) {
    indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    indicator.center = view.center
    view.addSubview(indicator)
  }
  
  func turnOnIndicator(indicator:UIActivityIndicatorView) {
    indicator.startAnimating()
    indicator.backgroundColor = UIColor.whiteColor()
  }
  
  func turnOffIndicator(indicator:UIActivityIndicatorView) {
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
    
    let entityCount = entityManager.entities.count
    
    if (entityCount == 0) {
      let emptyLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
      emptyLabel.text = "Enter your search above to fetch entities from Twitter!"
      emptyLabel.textAlignment = NSTextAlignment.Center
      emptyLabel.numberOfLines = 0
      tableView.backgroundView = emptyLabel
      tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    } else {
      
    }
    
    return entityCount

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
    turnOffIndicator(self.indicator)
  }
  
  // MARK: Helpers
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
        
    if (scope == "Entities" || scope == "All") {
      if (!searchText.isEmpty) {
        turnOnIndicator(self.indicator)
        tweetManager.fetchTweetsFromSearchText(searchText)
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

// MARK: UISearchBarDelegate delegate methods

extension MasterViewController: UISearchBarDelegate {
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    // To be implemented after other scope buttons are added
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)
  }
}



