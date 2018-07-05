
import UIKit
import Firebase
import FirebaseFirestore
import CoreData


class Detail1ViewController: UIViewController {
    
    
    var scrimmagePassedOver: Scrimmage?
    
   let coreDataController = CoreDataController.shared

    @IBOutlet var DT1backGroundPhotoImg: UIImageView!
    
    
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var venueNameLbl: UILabel!
    
    @IBOutlet var postCodeLbl: UILabel!
    
    @IBOutlet var timeLbl: UILabel!
    
    @IBOutlet var manNameLbl: UILabel!
    
    @IBOutlet var manNumberLbl: UILabel!
    
    @IBOutlet var priceLbl: UILabel!
    
    @IBOutlet var dateLbl: UILabel!
    
    @IBOutlet var participantsLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: [String : Any]())

        nameLbl.text = scrimmagePassedOver?.name
        venueNameLbl.text = scrimmagePassedOver?.venueName
        postCodeLbl.text = scrimmagePassedOver?.postCode
        timeLbl.text = "\(scrimmagePassedOver!.time)"
        manNameLbl.text = scrimmagePassedOver?.managerName
        manNumberLbl.text = scrimmagePassedOver?.managerNumber
        priceLbl.text = "£ \(String(describing: scrimmagePassedOver!.price))"
        dateLbl.text = scrimmagePassedOver?.date
        participantsLbl.text = "\(String(describing: scrimmagePassedOver!.participants))"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            DT1backGroundPhotoImg.image = #imageLiteral(resourceName: "backgoundBBall70")
        } else {
            DT1backGroundPhotoImg.image = #imageLiteral(resourceName: "theme2bacground270%")
        }
    }
    
    func entityExists(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "name")
        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try coreDataController.mainContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        if entitiesCount == 0{
            return true
        } else {
            return false
        }
        
    }
    
    
    @IBAction func add2Saved(_ sender: Any) {
        
        let newScrimmage = ScrimmageD(context: self.coreDataController.mainContext)
        
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
        
      //  SAVE THE CONTEXT
       // if entityExists(name: (scrimmagePassedOver?.name)!) == true{
        
        coreDataController.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        let alert = UIAlertController(title: "Saved!", message: "You have saved your Scrimmage.", preferredStyle: UIAlertControllerStyle.alert)
        
      //  add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    //    } else {
   //     let alert = UIAlertController(title: "hey", message: "You have saved this Scrimmage before.", preferredStyle: UIAlertControllerStyle.alert)
   //     alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
   //     self.present(alert, animated: true, completion: nil)
    //        }
        }
    
    @IBAction func participate(_ sender: Any) {
        
        var updatedParticipants = scrimmagePassedOver!
        updatedParticipants.participants = (updatedParticipants.participants) + 1
        FIRFirestoreService.shared.update(for: updatedParticipants, in: .scrimmages)
        
        
    }
    

    @IBAction func share(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: [scrimmagePassedOver?.name as Any], applicationActivities: nil)
        present(activityController,animated: true, completion: nil)
        
        
    }
   
}
