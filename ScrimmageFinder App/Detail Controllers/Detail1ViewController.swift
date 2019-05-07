
import UIKit
import Firebase
import FirebaseFirestore
import CoreData


class Detail1ViewController: UIViewController, Storyboarded {
    
    var coordinator: ScrimmagesCoordinator?
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
        
        //assigning data to labels
        nameLbl.text = scrimmagePassedOver?.name
        venueNameLbl.text = scrimmagePassedOver?.venueName
        postCodeLbl.text = scrimmagePassedOver?.postCode
        timeLbl.text = String(format:"%.2f",scrimmagePassedOver!.time)
        manNameLbl.text = scrimmagePassedOver?.managerName
        manNumberLbl.text = scrimmagePassedOver?.managerNumber
        priceLbl.text = "£ \(String(format:"%.2f", scrimmagePassedOver!.price))"
        dateLbl.text = scrimmagePassedOver?.date
        participantsLbl.text = "\(String(describing: scrimmagePassedOver!.participants))"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        // adjusting the theme when view will applear
        if themes == "theme1" {
            DT1backGroundPhotoImg.image = #imageLiteral(resourceName: "backgoundBBall70")
        } else {
            DT1backGroundPhotoImg.image = #imageLiteral(resourceName: "theme2bacground270%")
        }
    }
    
    
    //function that adds to CoreData
    @IBAction func add2Saved(_ sender: Any) {
        //checks if it already exist
        if entityExists(name: (scrimmagePassedOver?.name)!) == true{
       
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
        
       // SAVE THE CONTEXT and check if it already exist
        //saving contextf
        coreDataController.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        //add allert
        let alert = UIAlertController(title: "Saved!", message: "You have saved your Scrimmage.", preferredStyle: UIAlertControllerStyle.alert)
        
       // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
       }
        
        else {
         //add allert
        let alert = UIAlertController(title: "Sorry.", message: "You have saved this Scrimmage before.", preferredStyle: UIAlertControllerStyle.alert)
       //add button to allert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
       self.present(alert, animated: true, completion: nil)
        }
    }
    //function to check if Entity exist in the core data
    func entityExists(name: String) -> Bool {
        //fetching all the entities using predicate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScrimmageD")
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try coreDataController.mainContext.count(for: fetchRequest)
            print (entitiesCount)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        if entitiesCount > 0 {
            
            return false
            
        } else {
            
            return true
        }
    }
    //function to update the number of participants
    @IBAction func participate(_ sender: Any) {
        
        var updatedParticipants = scrimmagePassedOver!
        updatedParticipants.participants = (updatedParticipants.participants) + 1
        FIRFirestoreService.shared.update(for: updatedParticipants, in: .scrimmages)
        let alert = UIAlertController(title: "Added.", message: "You have added one more person to participants.", preferredStyle: UIAlertControllerStyle.alert)
        //add button to allert
        
        let Action = UIAlertAction.init(title: "OK", style: .default) { (UIAlertAction) in
            
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScrimmagesViewController") as! ScrimmagesViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
            
        }
        alert.addAction(Action)
        self.present(alert, animated: true, completion: nil)
        
    }
    //function to implememnt activity controller
    @IBAction func share(_ sender: Any) {
        
        let shareItem = "Hey Im going to \(scrimmagePassedOver!.name), do you want to join me?"
        
        let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        
        present(activityController,animated: true, completion: nil)
        
    }
   
}
