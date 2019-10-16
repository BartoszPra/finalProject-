import UIKit
import CoreData
import SilentScrolly
import FirebaseAuth

class SavedScrimmagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SilentScrollable, Storyboarded {
    
    var coordinator: SavedScrimmagesCoordinator?
    
    // vaariable of the silent scrollly controll
    var silentScrolly: SilentScrolly?
    
    //tableView outlet
    @IBOutlet var savedTableView: UITableView!
    
   //background image outlet
    @IBOutlet var SVbackGroundPhotoImg: UIImageView!
    
   // reference to coredata
    let coreDataController = CoreDataController.shared
  
    //array for coredata scrimmages
    var coreScrimmages = [ScrimmageSaved]()
    var savedScrimmages = [Scrimmage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: [String: Any]())
        fetchScrimmages()
        //notification to observ for notification for other controller
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     //user defaults for choosing theme
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            SVbackGroundPhotoImg.image = #imageLiteral(resourceName: "background2Bball70")
        } else {
            SVbackGroundPhotoImg.image = #imageLiteral(resourceName: "theme2Background260%")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return coreScrimmages.count
        return savedScrimmages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SVcell", for: indexPath)
        let coreScrimmage = savedScrimmages[indexPath.row]
        cell.textLabel?.text = coreScrimmage.name
        
        let name = coreScrimmage.venueName
        let price = coreScrimmage.price
        let time = coreScrimmage.time
        
        cell.detailTextLabel?.text = "Details: \(name), Price: £\(String(format: "%.2f", price)), Time: \(String(format: "%.2f", time))"
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SavedScrimmagesViewController.longTap))
        cell.addGestureRecognizer(longGesture)
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue trigger
        let topic = coreScrimmages[indexPath.row]
        self.coordinator?.goToDetail(with: topic)
       
}
    // long press function to add long press to table view and then delete the spacific row
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer) {
       
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        _ = longPress.state
        let locationInView = longPress.location(in: self.savedTableView)
        guard  let indexPath = self.savedTableView.indexPathForRow(at: locationInView) else {return}
        
        // aller to asf if you sure to delete
        let alert = UIAlertController(title: "Delete?",
                                      message: "Do you really want to delete this Scrimmage.",
                                      preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction.init(title: "Yes", style: .default) { (_) in
        
            // completeion to delete the scrimmage for m coredata
            let donara = self.coreScrimmages.remove(at: indexPath.row)
            self.savedTableView.deleteRows(at: [indexPath], with: .automatic)
            self.coreDataController.mainContext.delete(donara)
            self.coreDataController.saveContext()
            print("Long tap")
           
        }
        //allert action button to cancle
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(action)
        //presenting the allert
        self.present(alert, animated: true, completion: nil)
       
    }
   // swipe left to delte additiional posibility ot delte.
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           guard editingStyle == .delete else { return }
    
        let donara = coreScrimmages.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        coreDataController.mainContext.delete(donara)
        coreDataController.saveContext()
       }
    
    func getSavedScrimmagesIdList() {
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        FIRFirestoreService.shared.readWhereArray(from: .scrimmages,
                                             whereArray: "savedById",
                                             contains: userID,
                                             returning: Scrimmage.self) { (scrimmages) in
                                             self.savedScrimmages = scrimmages
                                             self.savedTableView.reloadData()
        }
    }
    
    func fetchScrimmagesFromRemote() {
        
    }
    
    func fetchScrimmages() {
        
        // Create a request to fetch ALL scrimmages
        let fetchRequest = ScrimmageSaved.fetchRequest() as NSFetchRequest<ScrimmageSaved>
        
        // Create sort decriptors to sort via age and firstName
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        // Add the sort descriptors to the fetch request
        fetchRequest.sortDescriptors = [nameSort]
        
        // Execute the fetch request & handle the error(s)
        do {
            let items = try coreDataController.mainContext.fetch(fetchRequest)
            coreScrimmages = items
           // savedTableView.reloadData()
        } catch {
            print("Error \(error.localizedDescription)")
        }
        
    }
    /// functions for silentScrolly controll.------------
    @objc func loadList(notification: NSNotification) {
        //load data here
    fetchScrimmages()
    savedTableView.reloadData()
   }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(savedTableView, followBottomView: tabBarController?.tabBar)
        self.getSavedScrimmagesIdList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        silentWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        silentDidDisappear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        silentWillTranstion()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        silentDidScroll()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        silentDidZoom() // Optional
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        showNavigationBar() // Optional
        return true
    }
}
