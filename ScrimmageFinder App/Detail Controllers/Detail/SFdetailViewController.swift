import UIKit
import Firebase
import FirebaseFirestore
import CoreData

class SFdetailViewController: UIViewController, Storyboarded {
    
    var coordinator: MyScrimmagesCoordinator?
    var scrimmagePassedOver: Scrimmage?
    let coreDataController = CoreDataController.shared
    
//    @IBOutlet var DT1backGroundPhotoImg: UIImageView!
//    @IBOutlet var nameLbl: UILabel!
//    @IBOutlet var venueNameLbl: UILabel!
//    @IBOutlet var postCodeLbl: UILabel!
//    @IBOutlet var timeLbl: UILabel!
//    @IBOutlet var manNameLbl: UILabel!
//    @IBOutlet var manNumberLbl: UILabel!
//    @IBOutlet var priceLbl: UILabel!
//    @IBOutlet var dateLbl: UILabel!
//    @IBOutlet var participantsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
 //       UserDefaults.standard.register(defaults: [String: Any]())
        //assigning data to labels
//        nameLbl.text = scrimmagePassedOver?.name
//        venueNameLbl.text = scrimmagePassedOver?.venueName
//        postCodeLbl.text = scrimmagePassedOver?.postCode
//        timeLbl.text = String(format: "%.2f", scrimmagePassedOver!.time)
//        manNameLbl.text = scrimmagePassedOver?.managerName
//        manNumberLbl.text = scrimmagePassedOver?.managerNumber
//        priceLbl.text = "£ \(String(format: "%.2f", scrimmagePassedOver!.price))"
//        dateLbl.text = scrimmagePassedOver?.date
//        participantsLbl.text = "\(String(describing: scrimmagePassedOver!.participants))"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let userDefaults = UserDefaults.standard
//        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
//        // adjusting the theme when view will applear
//        if themes == "theme1" {
//            DT1backGroundPhotoImg.image = #imageLiteral(resourceName: "backgoundBBall70")
//        } else {
//            DT1backGroundPhotoImg.image = #imageLiteral(resourceName: "theme2bacground270%")
//        }
    }
    
    //function that adds to CoreData
    //@IBAction func add2Saved(_ sender: Any) {
        
      //  saveScrimmageOnRemote()
        //checks if it already exist
    //    if coreDataController.entityExists(scrimmage: scrimmagePassedOver!) {

        // Crete new Scrimmage object
    //    let newScrimmage = ScrimmageSaved(context: self.coreDataController.mainContext)

       //  Add parts of the scrimmage
//        newScrimmage.name = scrimmagePassedOver?.name
//        newScrimmage.venueName = scrimmagePassedOver?.venueName
//        newScrimmage.managersName = scrimmagePassedOver?.managerName
//        newScrimmage.managersNumber = scrimmagePassedOver?.managerNumber
//        newScrimmage.postCode = scrimmagePassedOver?.postCode
//        newScrimmage.time = (scrimmagePassedOver!.time)
//        newScrimmage.price = (scrimmagePassedOver!.price)
//        newScrimmage.date = (scrimmagePassedOver!.date)
//        newScrimmage.participants = Int16((scrimmagePassedOver!.participants))

       // SAVE THE CONTEXT and check if it already exist
        //saving contextf
//        coreDataController.saveContext()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        //add allert
//        let alert = UIAlertController(title: "Saved!", message: "You have saved your Scrimmage.", preferredStyle: UIAlertController.Style.alert)

       // add an action (button)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//
//       } else {
         //add allert
//        let alert = UIAlertController(title: "Sorry.",
//                                      message: "You have saved this Scrimmage before.",
//                                      preferredStyle: UIAlertController.Style.alert)
       //add button to allert
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//       self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    func saveScrimmageOnRemote() {
        guard let currentScrimmageId = self.scrimmagePassedOver?.id else { return }
        guard let userID = Auth.auth().currentUser?.uid else {return}
        FIRFirestoreService.shared.updateSavedTable(for: currentScrimmageId, with: userID)
    }
    
    //function to update the number of participants
//    @IBAction func participate(_ sender: Any) {
//
//        var updatedParticipants = scrimmagePassedOver!
//        updatedParticipants.participants = (updatedParticipants.participants) + 1
//        FIRFirestoreService.shared.update(for: updatedParticipants, in: .scrimmages)
//        let alert = UIAlertController(title: "Added.",
//                                      message: "You have added one more person to participants.",
//                                      preferredStyle: UIAlertController.Style.alert)
//        //add button to allert
//        let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
//            self.navigationController?.popViewController(animated: true)
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//
//    }
    //function to implememnt activity controller
//    @IBAction func share(_ sender: Any) {
//
//        let shareItem = "Hey Im going to \(scrimmagePassedOver!.name), do you want to join me?"
//
//        let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
//
//        activityController.popoverPresentationController?.sourceView = self.view
//
//        present(activityController, animated: true, completion: nil)
//
//    }
   
}
