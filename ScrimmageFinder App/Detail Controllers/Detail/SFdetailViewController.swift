import UIKit
import Firebase
import FirebaseFirestore
import CoreData
import MapKit

class SFdetailViewController: UIViewController, Storyboarded, MKMapViewDelegate, UINavigationBarDelegate {
    
    private var coordinator: MyScrimmagesCoordinator?
    private var scrimmagePassedOver: Scrimmage!
    private let coreDataController = CoreDataController.shared
    private var userID: String!
    private var isSaveUsed: Bool!
    
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
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    
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
        navigationBar.delegate = self
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
        var updatedParticipants = scrimmagePassedOver!
        updatedParticipants.participants = (updatedParticipants.participants) + 1
        FIRFirestoreService.shared.update(for: updatedParticipants, in: .scrimmages)
        let alert = UIAlertController(title: "Added.",
                                      message: "You have added one more person to participants.",
                                      preferredStyle: UIAlertController.Style.alert)
        //add button to allert
        let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveScrimmageOnRemote() {
        guard let currentScrimmageId = self.scrimmagePassedOver?.id else { return }
        FIRFirestoreService.shared.updateSavedTable(for: currentScrimmageId, with: self.userID)
        self.scrimmagePassedOver = FIRFirestoreService.shared.refresh_getScrimmage(for: currentScrimmageId)
        self.setupUI()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    //function that adds to CoreData -- not used
    func saveScrimmageToLocalSaved() {
        if coreDataController.entityExists(scrimmage: scrimmagePassedOver!) {
            // Crete new Scrimmage object
            let newScrimmage = ScrimmageSaved(context: self.coreDataController.mainContext)
            //  Add parts of the scrimmage
            newScrimmage.name = scrimmagePassedOver?.name
            newScrimmage.venueName = scrimmagePassedOver?.venueName
            newScrimmage.managersName = scrimmagePassedOver?.managerName
            newScrimmage.managersNumber = scrimmagePassedOver?.managerNumber
            newScrimmage.postCode = scrimmagePassedOver?.postCode
            newScrimmage.time = (scrimmagePassedOver!.time)
            newScrimmage.price = (scrimmagePassedOver!.price)
            newScrimmage.date = (scrimmagePassedOver!.date)
            newScrimmage.participants = Int16((scrimmagePassedOver!.participants))
            //SAVE THE CONTEXT and check if it already exist
            //saving context
            coreDataController.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            //add allert
            let alert = UIAlertController(title: "Saved!", message: "You have saved your Scrimmage.", preferredStyle: UIAlertController.Style.alert)
            //add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //add allert
            let alert = UIAlertController(title: "Sorry.",
                                          message: "You have saved this Scrimmage before.",
                                          preferredStyle: UIAlertController.Style.alert)
            //add button to allert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupUI() {
        //assigning data to labels
        nameLabel.text = "Name: " + scrimmagePassedOver.name
        venueLabel.text = "Venue Name: " + scrimmagePassedOver.venueName
        addressLabel.text = "Addersss: " + scrimmagePassedOver.postCode
        startTimeLabel.text = "Start Time: " + String(format: "%.2f", scrimmagePassedOver.time)
        organizerNameLabel.text = "Organizer: " + scrimmagePassedOver.managerName
        contactNumberLabel.text = "Contact Number: " + scrimmagePassedOver.managerNumber
        priceLabel.text = "Price: £" + String(format: "%.2f", scrimmagePassedOver.price)
        dateLabel.text = "Date: " + scrimmagePassedOver.date
        numberOfParticipantsLabel.text = "People attending: " + String(describing: scrimmagePassedOver.participants)
        if isSaveUsed {
            saveButton.isHidden = checkIfScrimmageSaved(scrimmage: self.scrimmagePassedOver)
        } else {
            saveButton.isHidden = true
        }
        
    }
    
    func checkIfScrimmageSaved(scrimmage: Scrimmage) -> Bool {
        if scrimmage.savedById != nil {
            if !scrimmage.savedById!.isEmpty {
                if let _ = scrimmage.savedById?.first(where: {$0 == self.userID}) {
                    return true
                } else {
                    return false
                }
            }
            return false
        }
        return false
    }
}
