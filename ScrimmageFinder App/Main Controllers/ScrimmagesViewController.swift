import UIKit
import SilentScrolly
import MobileCoreServices
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ScrimmagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SilentScrollable, Storyboarded {
    
    var coordinator: ScrimmagesCoordinator?
    //let coreDataController = CoreDataController.shared
    @IBOutlet var titleItem: UINavigationItem!
    // vaariable of the silent scrollly controll
    var silentScrolly: SilentScrolly?
    // array of Scrimmages from firebase
    var scrimmages = [Scrimmage]()
    //array of filltered scrimmages by searchBar
    var filteredScrimmages = [Scrimmage]()
    //bool for searchBar
    var isSearching = false
    //searchbar outlet
    @IBOutlet var searchBar: UISearchBar!
    //background photo image outlet
    @IBOutlet var backGroundPhotoImg: UIImageView!    
    @IBOutlet var scrimmagesTableView: UITableView!
    let coreDataController = CoreDataController.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        scrimmagesTableView.dragDelegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.barStyle = .blackOpaque
        searchBar.setTextField(color: .black)
        ViewHelpers.setLogoAsNavigationTitle(imageName: "logoNoBackgroundBrighter", on: self)
        UserDefaults.standard.register(defaults: [String: Any]())
		let nib = UINib(nibName: "SavedScrimmagesCell", bundle: nil)
        scrimmagesTableView.register(nib, forCellReuseIdentifier: "SavedScrimmagesCell")
       
        // reading from database
        FIRFirestoreService.shared.readAll(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            self.scrimmages = scrimmages
            //self.deleteIfOld() // function to delete outdated scrimmages
            self.scrimmagesTableView.reloadData()
    }
}
    
    override func viewWillAppear(_ animated: Bool) {
        // adjusting the theme when view will applear
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            backGroundPhotoImg.image = #imageLiteral(resourceName: "backgoundBBall70")
        } else {
            backGroundPhotoImg.image = #imageLiteral(resourceName: "theme2bacground270%")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //checking is searchng is on and adjusting the tableview
        if isSearching {
            return filteredScrimmages.count
        }
       return scrimmages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SCcell", for: indexPath)
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedScrimmagesCell",
		for: indexPath) as? SavedScrimmagesCell else { return SavedScrimmagesCell() }
        //checking is searchng is on and adjusting the tableview
        if isSearching {
            let filteredScrimmage = filteredScrimmages[indexPath.row]
            cell.textLabel?.text = String(filteredScrimmage.name)
        } else {
            let scrimmage = scrimmages[indexPath.row]
			cell.configureCell(scrimmage: scrimmage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var scrimmage: Scrimmage
        
        if isSearching {
             scrimmage = filteredScrimmages[indexPath.row]
            
        } else {
             scrimmage = scrimmages[indexPath.row]
        }
        coordinator?.goToNewDetail(with: scrimmage, from: self)        
    }
    /**
     Below function is checking user taped sth in search bar.It first check for spaces and empty search bar and if so the bool is searching is set to false. Else the bool is true and function filters the array of all scrimmages
     with matching firts three characters.
     */
    
    //function to filter the searcBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //check for spaces and empty searchbar
        if searchBar.text == nil || searchBar.text!.isEmpty {
            isSearching = false
            view.endEditing(true)
            scrimmagesTableView.reloadData()
            
        } else {
            isSearching = true
            
            //upprecasing searchbar input
            //let firstTwo = searchBar.text?.prefix(3).uppercased()
            
            //checking is first two characters from post code are match with scrimmages post code
            //filteredScrimmages = scrimmages.filter {$0.postCode.hasPrefix(String(firstTwo!))}
            scrimmagesTableView.reloadData()
        }
    }
    
    //ONLY If YOU WANT TO DELETE - use for testing to quickly delete unwanterd scrimmages
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let scrimmage = scrimmages[indexPath.row]
        FIRFirestoreService.shared.delete(scrimmage, in: .scrimmages)
    }
    /**
     deleteOFOld checks if the date of the all scrimmages is older that today and if so delete is as those scrimmages already outdated. 
     */
    
    func deleteIfOld() {
        
        let current = Date()
        
        for scr in scrimmages {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            let sCdate = dateFormatter.date(from: "\(String(describing: scr.dateTime))")
            
            if sCdate! < current {
                FIRFirestoreService.shared.delete(scr, in: .scrimmages)
                
            }
        }
    }
   // drag and drop gesture recognizer working on IPad only
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let scr = scrimmages[ indexPath.row]
        
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            
            let data = scr.name.data(using: .utf8)
            completion(data, nil)
            return nil
        }
        
        let dragItem =  UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    // function to start drag and drop
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func goToAddScrimmagesClicked(_ sender: Any) {
        self.coordinator?.goToAddScrimmage()        
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        CoreDataController.shared.removeProfileImage()
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
        GIDSignIn.sharedInstance()?.signOut()
        FBSDKLoginManager().logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /// functions for silentScrolly controll.------------
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        silentDidLayoutSubviews()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        configureSilentScrolly(scrimmagesTableView, followBottomView: tabBarController?.tabBar)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        silentWillDisappear()
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        silentDidDisappear()
//    }
//    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        silentWillTranstion()
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        silentDidScroll()
//    }
//    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        silentDidZoom() // Optional
//    }
//    
//    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        showNavigationBar() // Optional
//        return true
//    }
    
}
// tableview drag delegate protocol functions 
extension ScrimmagesViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        return self.dragItems(for: indexPath)
    }
    
}
