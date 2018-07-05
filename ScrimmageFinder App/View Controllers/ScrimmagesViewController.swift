

import UIKit
import SilentScrolly



class ScrimmagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SilentScrollable {
    
    var silentScrolly: SilentScrolly?
    
    var scrimmages = [Scrimmage]()
    
    var filteredScrimmages = [Scrimmage]()
    
    var isSearching = false
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var backGroundPhotoImg: UIImageView!
    
    @IBOutlet var scrimmagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        UserDefaults.standard.register(defaults: [String : Any]())

        FIRFirestoreService.shared.read(from: .scrimmages, returning: Scrimmage.self) { (scrimmages) in
            self.scrimmages = scrimmages
            self.scrimmagesTableView.reloadData()
        
    }
}
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            backGroundPhotoImg.image = #imageLiteral(resourceName: "backgoundBBall70")
        } else {
            backGroundPhotoImg.image = #imageLiteral(resourceName: "theme2bacground270%")
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredScrimmages.count
        }
        
       return scrimmages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCcell", for: indexPath)
        
        if isSearching {
            let filteredScrimmage = filteredScrimmages[indexPath.row]
            cell.textLabel?.text = String(filteredScrimmage.name)
        }
        else {
            let scrimmage = scrimmages[indexPath.row]
            cell.textLabel?.text = String(scrimmage.name)
           // cell.detailTextLabel?.text = String(scrimmage.venueName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.performSegue(withIdentifier: "go2Details", sender: indexPath)
    
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier?.caseInsensitiveCompare("go2Details") == .orderedSame {
            
            if let indexPath = scrimmagesTableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! Detail1ViewController
                if isSearching {
                let topic = filteredScrimmages[indexPath.row]
                destinationViewController.scrimmagePassedOver = topic
                } else {
                let topic = scrimmages[indexPath.row]
                destinationViewController.scrimmagePassedOver = topic
                }
                
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            scrimmagesTableView.reloadData()
            
        } else {
            isSearching = true
            let firstTwo = searchBar.text?.prefix(3)
            filteredScrimmages = scrimmages.filter{$0.postCode.hasPrefix(String(firstTwo!))}
            scrimmagesTableView.reloadData()}
            
    }
    
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let scrimmage = scrimmages[indexPath.row]
        FIRFirestoreService.shared.delete(scrimmage, in: .scrimmages)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(scrimmagesTableView, followBottomView: tabBarController?.tabBar)
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
