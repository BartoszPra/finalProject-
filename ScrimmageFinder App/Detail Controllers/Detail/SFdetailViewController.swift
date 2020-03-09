import UIKit
import Firebase
import FirebaseFirestore
import CoreData
import MapKit

class CustomPin: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	
	init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D) {
		self.title = pinTitle
		self.subtitle = pinSubtitle
		self.coordinate = location
	}
}

class SFdetailViewController: UIViewController, Storyboarded, MKMapViewDelegate {
    
    //var coordinator: Coordinator?
    var coordinator: ScrimmagesDetailCoordinator?
    private var scrimmagePassedOver: Scrimmage!
    private let coreDataController = CoreDataController.shared
    private var userID: String!
    private var isSaveUsed: Bool!
    private var isParticipating: Bool!
    private var participantStatus: ParticipantsStatus!
    
	@IBOutlet weak var venueNameLabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addressLbl: UILabel!
	@IBOutlet weak var organizerNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var numberOfParticipantsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var userStatusLabel: UILabel!
	@IBOutlet weak var userStatusNameLabel: UILabel!
	
    init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle?, scrimmage: Scrimmage, isSaveUsed: Bool) {
        super.init(nibName: nibNameOrNil as String, bundle: nibBundleOrNil)
        self.isSaveUsed = isSaveUsed
        self.scrimmagePassedOver = scrimmage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser?.uid
        setupUI()
        UserDefaults.standard.register(defaults: [String: Any]())
		setMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        // adjusting the theme when view will applear
        if themes == "theme1" {
            backgroundImage.image = UIImage(named: "CourtBackgroundDark")
        } else {
            backgroundImage.image = UIImage(named: "CourtBackgroundDark")
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let shareItem = "Hey Im going to \(scrimmagePassedOver!.name), do you want to join me?"
        let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.saveScrimmageOnRemote()
    }
    
    @IBAction func participateButtonPressed(_ sender: Any) {
        guard let currentScrimmageId = self.scrimmagePassedOver?.id else { return }
        
        if !self.isUserAlreadyParticipating() {
            
            FIRFirestoreService.shared.addToParticipantsTable(for: currentScrimmageId, with: self.userID, status: 1) { (succesful) in
                if succesful {
					self.reloadScrimmage()
                    let alert = UIAlertController(title: "Added.",
                                                  message: "You are participating in this scrimmage.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
						//self.reloadScrimmage()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Sorry",
                                                  message: "Couldn't add you as participant.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
                        
			FIRFirestoreService.shared.removeFromParticipantsTable(for: currentScrimmageId, with: self.userID, status: .confirmed) { (success) in
                if success {
					self.reloadScrimmage()
                    let alert = UIAlertController(title: "Removed",
                                                  message: "You are removed from participants.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Sorry",
                                                  message: "There was a problem removing you from participants.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                        self.reloadScrimmage()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func saveScrimmageOnRemote() {
        guard let currentScrimmageId = self.scrimmagePassedOver?.id else { return }
        FIRFirestoreService.shared.updateSavedTable(for: currentScrimmageId, with: self.userID) { (success) in
            if success {
                
                let alert = UIAlertController(title: "Saved",
                                              message: "This Scrimmage is added to your saved",
                                              preferredStyle: UIAlertController.Style.alert)
                //add button to allert
                let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    self.reloadScrimmage()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Sorry",
                                              message: "There was a problem saving you scrimmage.",
                                              preferredStyle: UIAlertController.Style.alert)
                //add button to allert
                let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    self.reloadScrimmage()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func setupUI() {
        //assigning data to labels
        nameLabel.text = "    " + scrimmagePassedOver.name
		venueNameLabel.text = "    " + scrimmagePassedOver.venueName
		addressLbl.text = "    " + scrimmagePassedOver.address
		startTimeLabel.text = "    " + scrimmagePassedOver.getTime()
        organizerNameLabel.text = "    " + scrimmagePassedOver.managerName
        contactNumberLabel.text = "    " + scrimmagePassedOver.managerNumber
        priceLabel.text = "    " + String(format: "%.2f", scrimmagePassedOver.price)
        dateLabel.text = "    " + scrimmagePassedOver.getDate()
        numberOfParticipantsLabel.text = "    " + String(describing: scrimmagePassedOver.participants.count)
		self.typeLabel.text = "    " + ScrimmageType(rawValue: scrimmagePassedOver.currentType)!.description
		self.statusLabel.text = "    " + ScrimmageStatus(rawValue: scrimmagePassedOver.currentStatus)!.description
        
        if isUserAlreadyParticipating() {
            self.participateButton.setTitle("Unparticipate", for: .normal)
        } else {
            self.participateButton.setTitle("Participate", for: .normal)
        }
        
        if isSaveUsed {
            saveButton.isHidden = checkIfScrimmageSaved(scrimmage: self.scrimmagePassedOver)
        } else {
            saveButton.isHidden = true
        }
        
		if isUserAlreadyParticipating() {
			DispatchQueue.main.async {
				self.userStatusLabel.isHidden = false
				self.userStatusNameLabel.isHidden = false
				if self.participantStatus == .confirmed {
					self.userStatusLabel.textColor = .green
				} else {
					self.userStatusLabel.textColor = .red
				}
				self.userStatusNameLabel.text = "You:"
				self.userStatusLabel.text = "    " + self.participantStatus.description
			}
		} else {
			DispatchQueue.main.async {
				self.userStatusLabel.isHidden = true
				self.userStatusNameLabel.isHidden = true
			}
		}
    }
    
    @IBAction func viewParticipatingUsersButtonClicked(_ sender: Any) {
        self.coordinator?.goToViewUsers(with: scrimmagePassedOver!.participants, from: self)
    }
    
    func isUserAlreadyParticipating() -> Bool {
        if !self.scrimmagePassedOver.participants.isEmpty {
            if let participant = self.scrimmagePassedOver.participants.first(where: { $0.keys.contains(self.userID)}) {
                self.participantStatus = participant.values.first
                self.isParticipating = true
                return true
            } else {
                self.participantStatus = .none
                self.isParticipating = false
                return false
            }
        }
        return false
    }

    func checkIfScrimmageSaved(scrimmage: Scrimmage) -> Bool {
        if !scrimmage.savedById.isEmpty {
            if let _ = scrimmage.savedById.first(where: {$0 == self.userID}) {
                return true
            } else {
                return false
            }
        }
        return false
        
    }
	
	func setMap() {
		let location = CLLocationCoordinate2D(latitude: scrimmagePassedOver.geopoint.latitude, longitude: scrimmagePassedOver.geopoint.longitude)
		let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
		self.mapView.setRegion(region, animated: true)
		
		let pin = CustomPin(pinTitle: scrimmagePassedOver.name, pinSubtitle: scrimmagePassedOver.getTime(), location: location)
		self.mapView.addAnnotation(pin)
	}
    
    func reloadScrimmage() {
        guard let scrimmageId = scrimmagePassedOver.id else { return }
        FIRFirestoreService.shared.readOne(from: .scrimmages, with: scrimmageId, returning: Scrimmage.self) { (scrimmage) in
            self.scrimmagePassedOver = scrimmage
            self.setupUI()
        }
    }
}
