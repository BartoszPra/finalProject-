import Firebase
import FirebaseFirestore
import UIKit

class AddScrimmageViewController: UIViewController, Storyboarded {
   
    //text fields outlets 
   
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

        UserDefaults.standard.register(defaults: [String: Any]())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // adjusting the theme when view will applear
        let userDefaults = UserDefaults.standard
        guard let themes = userDefaults.string(forKey: "user_theme") else {return}
        
        if themes == "theme1" {
            addSCBackGroundPhotoImg.image = #imageLiteral(resourceName: "backgoundBBall70")
        } else {
            addSCBackGroundPhotoImg.image = #imageLiteral(resourceName: "theme2bacground270%")
            
        }
        
    }
    
   //function to add number and name to contact list
    @IBAction func addContact(_ sender: Any) {
       //creating allert that will be used for text field check
        let alert = UIAlertController(title: "Error",
                                      message: "Please fill out all the Informations Correctly!",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        //checking for spaces and if its empty
        if (nameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        //checking for spaces and if its empty
        else if (venueNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
           
            self.present(alert, animated: true, completion: nil)
        }
        //checking for spaces and if its empty
        else if (postCodeTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        //checking for spaces and if its empty
        else if (managerNameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
           
            self.present(alert, animated: true, completion: nil)
        }
        //checking for spaces and if its empty
        else if (managersNumberTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
           
            self.present(alert, animated: true, completion: nil)
        }
        //checking for spaces and if its empty
        else if (priceTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        //checking for spaces and if its empty
        else if (timeTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        //checking for spaces and if its empty
        else if (dateTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("noooo")
            
            self.present(alert, animated: true, completion: nil)
        }
        //validating date
        else if !isValidDate(dateString: "\(dateTF.text!) \(timeTF.text!)") {
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            //converting time to double
            let timeString = timeTF.text!
            let time = Double(timeString)
            
            //converting price to double
            let priceString = priceTF.text!
            let price = Double(priceString)
                        
            // composing a scrimmage
            let scrimmage = Scrimmage(name: self.nameTF.text!,
                                      vanueName: self.venueNameTF.text!,
                                      postCode: self.postCodeTF.text!.uppercased(),
                                      time: time!, managerName: self.managerNameTF.text!,
                                      managerNumber: self.managersNumberTF.text!,
                                      price: price!,
                                      date: self.dateTF.text!,
                                      createdById: Auth.auth().currentUser!.uid,
                                      currentStatus: .on,
                                      currentType: .open)
            // creating a scrimmage
                FIRFirestoreService.shared.create(for: scrimmage, in: .scrimmages)
            //allert if added
            let alert = UIAlertController(title: "Added!",
                                          message: "You have added your Scrimmage to Data Base.",
                                          preferredStyle: UIAlertController.Style.alert)
            
            //clearing the text fields
            let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                
                self.nameTF.text = ""
                
                self.venueNameTF.text = ""
                
                self.postCodeTF.text = ""
                
                self.timeTF.text = ""
                
                self.managerNameTF.text = ""
                
                self.managersNumberTF.text = ""
                
                self.priceTF.text = ""
                
                self.dateTF.text = ""
            }
            
            //  add an action (button)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            }
    }
    // function to validate date and time
    func isValidDate(dateString: String) -> Bool {
        
        //date formmater to format string into date
        let dateFormatterGet = DateFormatter()
        //date format
        dateFormatterGet.dateFormat = "dd.MM.yyyy HH:mm"
        let date = Date()
        let dateFromString = dateFormatterGet.date(from: dateString)
        //checking if its nill and if the date is not olderthe current date
        if (dateFromString != nil) && (dateFromString! >= date) {
            return true
        } else {
            return false
        }
    }
    //hidding keyboard after touching somewhere elsle
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
