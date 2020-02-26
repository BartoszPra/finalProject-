import UIKit
import Firebase
import FirebaseFirestore
import CoreData
import MapKit

class SFdetailViewController: UIViewController, Storyboarded, MKMapViewDelegate {
    
    //var coordinator: Coordinator?
    var coordinator: ScrimmagesDetailCoordinator?
    private var scrimmagePassedOver: Scrimmage!
    private let coreDataController = CoreDataController.shared
    private var userID: String!
    private var isSaveUsed: Bool!
    private var isParticipating: Bool!
    private var participantStatus: ParticipantsStatus!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
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
                    let alert = UIAlertController(title: "Added.",
                                                  message: "You are participating in this scrimmage.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                        self.reloadScrimmage()
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
                    let alert = UIAlertController(title: "Removed",
                                                  message: "You are removed from participants.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                        self.reloadScrimmage()
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
    
    //function that adds to CoreData -- not used
//    func saveScrimmageToLocalSaved() {
//        if coreDataController.entityExists(scrimmage: scrimmagePassedOver!) {
//            // Crete new Scrimmage object
//            let newScrimmage = ScrimmageSaved(context: self.coreDataController.mainContext)
//            //  Add parts of the scrimmage
//            newScrimmage.name = scrimmagePassedOver?.name
//            newScrimmage.venueName = scrimmagePassedOver?.venueName
//            newScrimmage.managersName = scrimmagePassedOver?.managerName
//            newScrimmage.managersNumber = scrimmagePassedOver?.managerNumber
//            newScrimmage.postCode = scrimmagePassedOver?.postCode
//            newScrimmage.time = (scrimmagePassedOver!.time)
//            newScrimmage.price = (scrimmagePassedOver!.price)
//            newScrimmage.date = (scrimmagePassedOver!.date)
//            newScrimmage.participants = Int16((scrimmagePassedOver!.participants))
//            //SAVE THE CONTEXT and check if it already exist
//            //saving context
//            coreDataController.saveContext()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//            //add allert
//            let alert = UIAlertController(title: "Saved!", message: "You have saved your Scrimmage.", preferredStyle: UIAlertController.Style.alert)
//            //add an action (button)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            //add allert
//            let alert = UIAlertController(title: "Sorry.",
//                                          message: "You have saved this Scrimmage before.",
//                                          preferredStyle: UIAlertController.Style.alert)
//            //add button to allert
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    func setupUI() {
        //assigning data to labels
        nameLabel.text = "Name: " + scrimmagePassedOver.name
        venueLabel.text = "Venue Name: " + "" //scrimmagePassedOver.venueName
        addressLabel.text = "Addersss: " + "" //scrimmagePassedOver.postCode
        startTimeLabel.text = "Start Time: " + ""//String(format: "%.2f", scrimmagePassedOver.time)
        organizerNameLabel.text = "Organizer: " + scrimmagePassedOver.managerName
        contactNumberLabel.text = "Contact Number: " + scrimmagePassedOver.managerNumber
        priceLabel.text = "Price: £" + String(format: "%.2f", scrimmagePassedOver.price)
        dateLabel.text = "Date: " + scrimmagePassedOver.date
        numberOfParticipantsLabel.text = "People attending: " + String(describing: scrimmagePassedOver.participants.count)
        self.typeLabel.text = "Scrimmage type: " + String(describing: scrimmagePassedOver.currentType)
        self.statusLabel.text = "Scrimmage status: " + String(describing: scrimmagePassedOver.currentStatus)
        
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
            self.userStatusLabel.isHidden = false
            if self.participantStatus == .confirmed {
                self.userStatusLabel.textColor = .green
            } else {
                self.userStatusLabel.textColor = .red
            }
            self.userStatusLabel.text = "Me: " + self.participantStatus.description
        } else {
            self.userStatusLabel.isHidden = true
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
    
    func reloadScrimmage() {
        guard let scrimmageId = scrimmagePassedOver.id else { return }
        FIRFirestoreService.shared.readOne(from: .scrimmages, with: scrimmageId, returning: Scrimmage.self) { (scrimmage) in
            self.scrimmagePassedOver = scrimmage
            self.setupUI()
        }
    }
}
