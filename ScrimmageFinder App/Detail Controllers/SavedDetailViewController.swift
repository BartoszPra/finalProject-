

import UIKit
import Contacts
import EventKit

class SavedDetailViewController: UIViewController {
    
    
    var scrimmagePassedOver2: ScrimmageD?

    //outlet for background image
    @IBOutlet var DT2backGroundPhotoImg: UIImageView!
    
    //labels outlets
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var venueNameLbl: UILabel!
    
    @IBOutlet var postCode: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var manName: UILabel!
    
    @IBOutlet var manNumber: UILabel!
    
    @IBOutlet var price: UILabel!
    
    @IBOutlet var dateLbl: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register user defaults
        UserDefaults.standard.register(defaults: [String : Any]())
        //assinging data to labels
        nameLbl.text = scrimmagePassedOver2?.name
        venueNameLbl.text = scrimmagePassedOver2?.venueName
        postCode.text = scrimmagePassedOver2?.postCode
        time.text = "\(String(format:"%.2f", scrimmagePassedOver2!.time))"
        manName.text = scrimmagePassedOver2?.managersName
        manNumber.text = scrimmagePassedOver2?.managersNumber
        price.text = "£ \(String(format:"%.2f",scrimmagePassedOver2!.price))"
        dateLbl.text = scrimmagePassedOver2?.date
        
    }
    //changing theme
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            DT2backGroundPhotoImg.image = #imageLiteral(resourceName: "background2Bball70")
        } else {
            DT2backGroundPhotoImg.image = #imageLiteral(resourceName: "theme2Background260%")
            
        }
    }
    //creating a new contact
    func createCNContactWithFirstName(_ firstName: String, phone: String?) {
        // create contact with mandatory values: first and last name
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        let contactPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone!))
        newContact.phoneNumbers = [contactPhone]
        
        do {
            let newContactRequest = CNSaveRequest()
            newContactRequest.add(newContact, toContainerWithIdentifier: nil)
            try CNContactStore().execute(newContactRequest)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch {
            print("I was unable to create the new contact. An error occurred.")
        }
    }
     //function to implememnt adding to contacts
    @IBAction func addToContacts(_ sender: Any) {
        let firstName = scrimmagePassedOver2?.managersName
        let phone = scrimmagePassedOver2?.managersNumber!
        createCNContactWithFirstName(firstName!, phone: phone)
        let alert = UIAlertController(title: "Contact Added", message: "You have added this contact to you list.", preferredStyle: UIAlertControllerStyle.alert)
        
        //  add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
     //function to implememnt activity controller
    @IBAction func share(_ sender: Any) {
        
        let shareItem = "Hey Im going to \(scrimmagePassedOver2!.name!),do you want to join me?"
        
        let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        present(activityController,animated: true, completion: nil)
        
    }
    
    //function that adds to the callendar
    @IBAction func addToCallendar(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        
        guard let date = dateFormatter.date(from: "\(String(describing: scrimmagePassedOver2!.date!)) \(String(describing: scrimmagePassedOver2!.time))") else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")}
        
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .hour, value: 2, to: date) else {return}
        
        print("\(String(describing: scrimmagePassedOver2!.date!)) \(String(describing: scrimmagePassedOver2!.time))")
        
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { ( granted, error) in
            
            if (granted) && (error == nil) {
                
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.scrimmagePassedOver2?.name
                event.startDate = date
                event.endDate = endDate
                event.notes = "\(String(describing: self.scrimmagePassedOver2!.venueName!)), \(String(describing: self.scrimmagePassedOver2!.postCode!)), \(String(format: "%.2f", self.scrimmagePassedOver2!.time))"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("error: \(error)")
                }
                print("Save Event")
                
                let alert = UIAlertController(title: "Added!", message: "You have added your Scrimmage to Callendar.", preferredStyle: UIAlertControllerStyle.alert)
                //  add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                print("error: \(String(describing: error))")
                let alert = UIAlertController(title: "Error!", message: "Sorry Couldn't add it to Callendar", preferredStyle: UIAlertControllerStyle.alert)

                //  add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
