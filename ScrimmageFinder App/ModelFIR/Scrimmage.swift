

import Foundation
//protocol for when the function will need id to be performed like delete and update
protocol  Identifiable {
    var id: String? {get set}
}

//scrimmgage struct with properties
struct Scrimmage: Codable, Identifiable  {
    var id: String? = nil
    var name: String
    var venueName: String
    var postCode: String
    var time: Double
    var managerName: String
    var managerNumber: String
    var price: Double
    var date: String
    var participants: Int

    //scrimmage struct init
    init (name: String, vanueName: String, postCode: String, time: Double, managerName: String, managerNumber: String, price: Double, date: String){
         self.name = name
         self.venueName = vanueName
         self.postCode = postCode
         self.time = time
         self.managerName = managerName
         self.managerNumber = managerNumber
         self.price = price
         self.date = date
         self.participants = 0
        
    }
    
}

