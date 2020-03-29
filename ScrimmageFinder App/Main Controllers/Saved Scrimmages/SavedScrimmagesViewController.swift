import UIKit
import CoreData
import SilentScrolly
import FirebaseAuth

class SavedScrimmagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SilentScrollable, Storyboarded {
    
    var coordinator: SavedScrimmagesCoordinator?
    // vaariable of the silent scrollly controll
    var silentScrolly: SilentScrolly?
    @IBOutlet weak var emptyListLabel: UILabel!
    //tableView outlet
    @IBOutlet var savedTableView: UITableView!
    // reference to coredata
    let coreDataController = CoreDataController.shared
    //array for coredata scrimmages
    var coreScrimmages = [ScrimmageSaved]()
    var savedScrimmages = [Scrimmage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved"
        UserDefaults.standard.register(defaults: [String: Any]())
        //fetchScrimmages()
        self.savedTableView.delegate = self
        self.savedTableView.dataSource = self        
        //notification to observ for notification for other controller
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        let nib = UINib(nibName: "SavedScrimmagesCell", bundle: nil)
        savedTableView.register(nib, forCellReuseIdentifier: "SavedScrimmagesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //user defaults for choosing theme
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            // SVbackGroundPhotoImg.image = #imageLiteral(resourceName: "background2Bball70")
        } else {
            // SVbackGroundPhotoImg.image = #imageLiteral(resourceName: "theme2Background260%")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedScrimmages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedScrimmagesCell",
                                                       for: indexPath) as? SavedScrimmagesCell else { return SavedScrimmagesCell() }
        
        if !self.savedScrimmages.isEmpty {
            updateUI()
            let scrimmage = savedScrimmages[indexPath.row]
			cell.configureCell(scrimmage: scrimmage)
            return cell
        } else {
            updateUI()
            cell.cellLBL.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue trigger
        let scrimmage = savedScrimmages[indexPath.row]
        //self.coordinator?.goToDetail(with: topic)
        self.coordinator?.goToNewDetail(with: scrimmage, from: self)
        
    }
    
    // swipe left to delte additiional posibility ot delte.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let toRemoveSavedScrimmage = savedScrimmages[indexPath.row]
        
        guard let toRemoveFromSavedId = toRemoveSavedScrimmage.id else {return}
        self.deleteFromSavedList(for: toRemoveFromSavedId, at: indexPath)
        // core data delete
        //        let donara = coreScrimmages.remove(at: indexPath.row)
        //        tableView.deleteRows(at: [indexPath], with: .automatic)
        //        coreDataController.mainContext.delete(donara)
        //        coreDataController.saveContext()
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
    
    func deleteFromSavedList(for scrimmageId: String, at indexPath: IndexPath) {
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        if FIRFirestoreService.shared.deleteFromSavedBy(for: scrimmageId, with: userID) {
            savedScrimmages.remove(at: indexPath.row)
            self.savedTableView.deleteRows(at: [indexPath], with: .automatic)
            self.savedTableView.reloadData()
        }
    }
    
    /// functions for silentScrolly controll.------------
    @objc func loadList(notification: NSNotification) {
        //load data here
        // fetchScrimmages()
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
        self.updateUI()
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
    
    func updateUI() {
        if self.savedScrimmages.isEmpty {
            self.emptyListLabel.text = "No saved Scrimmages"
        } else {
            self.emptyListLabel.text = ""
        }
    }
}
