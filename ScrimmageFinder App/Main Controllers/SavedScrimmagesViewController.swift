

import UIKit
import CoreData
import SilentScrolly



class SavedScrimmagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SilentScrollable
    {
    // vaariable of the silent scrollly controll
    var silentScrolly: SilentScrolly?
    
    //tableView outlet
    @IBOutlet var savedTableView: UITableView!
    
   //background image outlet
    @IBOutlet var SVbackGroundPhotoImg: UIImageView!
    
   // reference to coredata
    let coreDataController = CoreDataController.shared
  
    //array for coredata scrimmages
    var coreScrimmages = [ScrimmageD]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: [String : Any]())
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
        return coreScrimmages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SVcell", for: indexPath)
        let coreScrimmage = coreScrimmages[indexPath.row]
        cell.textLabel?.text = coreScrimmage.name
        cell.detailTextLabel?.text = "Details: \(coreScrimmage.venueName!), Price: £\(String(format:"%.2f",coreScrimmage.price)), Time: \(String(format:"%.2f",coreScrimmage.time))"
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SavedScrimmagesViewController.longTap))
        cell.addGestureRecognizer(longGesture)
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue trigger
        self.performSegue(withIdentifier: "go2SVDetails", sender: indexPath)
       
}
    // long press function to add long press to table view and then delete the spacific row
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer) {
       
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        _ = longPress.state
        let locationInView = longPress.location(in: self.savedTableView)
        guard  let indexPath = self.savedTableView.indexPathForRow(at: locationInView) else {return}
        
        // aller to asf if you sure to delete
        let alert = UIAlertController(title: "Delete?", message: "Do you really want to delete this Scrimmage.", preferredStyle: UIAlertControllerStyle.alert)
        let Action = UIAlertAction.init(title: "Yes", style: .default) { (UIAlertAction) in
        
            // completeion to delete the scrimmage for m coredata
            let donara = self.coreScrimmages.remove(at: indexPath.row)
            self.savedTableView.deleteRows(at: [indexPath], with: .automatic)
            self.coreDataController.mainContext.delete(donara)
            self.coreDataController.saveContext()
            print("Long tap")
           
        }
        //allert action button to cancle
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(Action)
        //presenting the allert
        self.present(alert, animated: true, completion: nil)
       
    }
    // function to prepare for seque for selecter row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier?.caseInsensitiveCompare("go2SVDetails") == .orderedSame {
            
            if let indexPath = savedTableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! SavedDetailViewController
                let topic = coreScrimmages[indexPath.row]
                destinationViewController.scrimmagePassedOver2 = topic
                
            }
        }
    }
   // swipe left to delte additiional posibility ot delte.
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
           guard editingStyle == .delete else { return }
    
        let donara = coreScrimmages.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        coreDataController.mainContext.delete(donara)
        coreDataController.saveContext()
       }
    
    func fetchScrimmages() {
        
        // Create a request to fetch ALL scrimmages
        let fetchRequest = ScrimmageD.fetchRequest() as NSFetchRequest<ScrimmageD>
        
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
    @objc func loadList(notification: NSNotification){
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
