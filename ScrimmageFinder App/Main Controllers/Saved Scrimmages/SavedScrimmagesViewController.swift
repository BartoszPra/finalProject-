import UIKit
import CoreData
import SilentScrolly
import FirebaseAuth

class SavedScrimmagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var coordinator: SavedScrimmagesCoordinator?
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet var savedTableView: UITableView!
	@IBOutlet weak var segmentedControll: UISegmentedControl!
    var savedScrimmages = [ScrimmageViewModel]()
	var createdScrimmages = [ScrimmageViewModel]()
	var toDisplayArray = [ScrimmageViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Scrimmages"
		self.view.backgroundColor = .black
		let image = UIImage(named: "black")!.alpha(0.7)
		navigationController?.navigationBar.setBackgroundImage(image, for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		segmentedControll.setTitleTextAttributes(titleTextAttributes, for: .normal)
		segmentedControll.setTitleTextAttributes(titleTextAttributes, for: .selected)
		segmentedControll.addTarget(self, action: #selector(handleSegmentedChange), for: .valueChanged)
		self.getSavedScrimmages()
		self.getCreatedScrimmages()
        self.savedTableView.delegate = self
        self.savedTableView.dataSource = self
        let nib = UINib(nibName: "SavedScrimmagesCell", bundle: nil)
        savedTableView.register(nib, forCellReuseIdentifier: "SavedScrimmagesCell")
		self.updateUI()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDisplayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedScrimmagesCell",
                                                       for: indexPath) as? SavedScrimmagesCell else { return SavedScrimmagesCell() }
        
        if !self.toDisplayArray.isEmpty {
            updateUI()
            let scrimmage = toDisplayArray[indexPath.row]
			cell.configureCell(scrimmage: scrimmage)
            return cell
        } else {
            updateUI()
            cell.cellLBL.text = ""
            return cell
        }
    }
	
	override func viewDidAppear(_ animated: Bool) {
		self.handleSegmentedChange()
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scrimmage = toDisplayArray[indexPath.row]
		let cell = tableView.cellForRow(at: indexPath) as? SavedScrimmagesCell
		self.coordinator?.goToNewDetail(with: scrimmage, from: self, image: cell!.cellImage.image!)
        
    }
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		if segmentedControll.selectedSegmentIndex == 1 {
			return .delete
		}
		return .none
	}
    
    // swipe left to delte additiional posibility ot delte.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let toRemoveSavedScrimmage = savedScrimmages[indexPath.row]
        guard let toRemoveFromSavedId = toRemoveSavedScrimmage.id else {return}
        self.deleteFromSavedList(for: toRemoveFromSavedId, at: indexPath)
    }
	
	@objc func handleSegmentedChange() {
		switch segmentedControll.selectedSegmentIndex {
		case 0 :
			toDisplayArray = createdScrimmages
		case 1:
			toDisplayArray = savedScrimmages
		default:
			toDisplayArray = createdScrimmages
		}
		self.savedTableView.reloadData()
	}
	
	func getCreatedScrimmages() {
		guard let userID = Auth.auth().currentUser?.uid else {return}
		FIRFirestoreService.shared.readWhere(from: .scrimmages,
                                             whereFld: "createdById",
                                             equalsTo: userID,
                                             returning: Scrimmage.self) { (scrimmages) in
												self.createdScrimmages = scrimmages.map({return ScrimmageViewModel(scrimmage: $0)})
												self.toDisplayArray = self.createdScrimmages
												self.savedTableView.reloadData()
        }
	}
	    
    func getSavedScrimmages() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
		return FIRFirestoreService.shared.readWhereArray(from: .scrimmages,
                                                  whereArray: "savedById",
                                                  contains: userID,
                                                  returning: Scrimmage.self) { (scrimmages) in
													self.savedScrimmages = scrimmages.map({return ScrimmageViewModel(scrimmage: $0)})
        }
    }
    
    func deleteFromSavedList(for scrimmageId: String, at indexPath: IndexPath) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
		FIRFirestoreService.shared.deleteFromSavedBy(for: scrimmageId, with: userID) { (succ) in
			if succ {
				self.toDisplayArray = self.savedScrimmages
				self.savedTableView.reloadData()
			}
		}
    }
    
    func updateUI() {
        if self.savedScrimmages.isEmpty {
            self.emptyListLabel.text = "No saved Scrimmages"
        } else {
            self.emptyListLabel.text = ""
        }
    }
}
