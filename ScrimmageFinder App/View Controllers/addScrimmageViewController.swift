
import Firebase
import FirebaseFirestore
import UIKit

class addScrimmageViewController: UIViewController {
   
   
    @IBOutlet var addSCBackGroundPhotoImg: UIImageView!
    
    @IBOutlet var nameTF: UITextField!
    
    @IBOutlet var venueNameTF: UITextField!
    
    @IBOutlet var postCodeTF: UITextField!
    
    @IBOutlet var timeTF: UITextField!
    
    @IBOutlet var managerNameTF: UITextField!
    
    @IBOutlet var managersNumberTF: UITextField!
    
    @IBOutlet var priceTF: UITextField!
    
    @IBOutlet var dateTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.register(defaults: [String : Any]())
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            addSCBackGroundPhotoImg.image = #imageLiteral(resourceName: "backgoundBBall70")
        } else {
            addSCBackGroundPhotoImg.image = #imageLiteral(resourceName: "theme2bacground270%")
            
        }
        
    }
    
   
    @IBAction func addContact(_ sender: Any) {
        
        let alert = UIAlertController(title: "Error", message: "Please fill out all the Informations Correctly!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
    
        if (nameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        else if (venueNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
           
            self.present(alert, animated: true, completion: nil)
        }
        else if (postCodeTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        else if (managerNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
           
            self.present(alert, animated: true, completion: nil)
        }
        else if (managersNumberTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
           
            self.present(alert, animated: true, completion: nil)
        }
        else if (priceTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        else if (timeTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        else if isValidDate(dateString: dateTF.text!) {
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            let timeString = timeTF.text!
            let time = Double(timeString)
            
            let priceString = priceTF.text!
            let price = Double(priceString)
            
            let scrimmage = Scrimmage(name: self.nameTF.text!, vanueName: self.venueNameTF.text!, postCode: self.postCodeTF.text!, time: time!, managerName: self.managerNameTF.text!, managerNumber: self.managersNumberTF.text!, price: price!, date: self.dateTF.text!)
                
                FIRFirestoreService.shared.create(for: scrimmage, in: .scrimmages)
            
            let alert = UIAlertController(title: "Added!", message: "You have added your Scrimmage to Data Base.", preferredStyle: UIAlertControllerStyle.alert)
            
            //  add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            }
    }
    
    func isValidDate(dateString: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd.MM.YYYY"
        if let _ = dateFormatterGet.date(from: dateString) {
            return false
        } else {
            return true
        }
    }
    
    
}
