import Foundation
import FirebaseAuth
import Firebase
//protocol for when the function will need id to be performed like delete and update
protocol  Identifiable {
    var id: String? {get set}
}

//scrimmgage struct with properties
class Scrimmage: NSObject, Codable, Identifiable {
    
    @objc var id: String?
    @objc var name: String
	@objc var venueName: String
    @objc var managerName: String
    @objc var managerNumber: String
    @objc var price: Double
    @objc var createdById: String
    @objc var savedById: [String]
    @objc var currentStatus: Int
    @objc var currentType: Int
	var participants: [String: ParticipantsStatus]
	@objc var address: String
	@objc var dateTime: Date
	@objc var geopoint: GeoPoint
	@objc var notes: String
	@objc var chatId: String
	@objc var imageUrl: String
	@objc var occurance: Int
		
	//new scrimmaage struct init
	init (name: String, venueName: String, address: String, dateTime: Date, managerName: String, managerNumber: String, price: Double, createdById: String, currentStatus: Int, currentType: Int, participants: [String: ParticipantsStatus], geopoint: GeoPoint, notes: String, chatId: String, imageUrl: String, occurance: Int) {
        self.name = name
		self.venueName = venueName
		self.address = address
		self.dateTime = dateTime
        self.managerName = managerName
        self.managerNumber = managerNumber
        self.price = price
        self.createdById = Auth.auth().currentUser!.uid
        self.savedById = [String]()
        self.currentStatus = currentStatus
        self.currentType = currentType
        self.participants = participants
		self.geopoint = geopoint
		self.notes = notes
		self.chatId = chatId
		self.imageUrl = imageUrl
		self.occurance = occurance
    }
	
	init(id: String, name: String, venueName: String, address: String, dateTime: Date, managerName: String, managerNumber: String, price: Double, createdById: String, currentStatus: Int, currentType: Int, participants: [String: ParticipantsStatus], geopoint: GeoPoint, notes: String, chatId: String, imageUrl: String, occurance: Int) {
		
		self.id = id
		self.name = name
		self.venueName = venueName
		self.address = address
		self.dateTime = dateTime
        self.managerName = managerName
        self.managerNumber = managerNumber
        self.price = price
        self.createdById = Auth.auth().currentUser!.uid
        self.savedById = [String]()
        self.currentStatus = currentStatus
        self.currentType = currentType
        self.participants = participants
		self.geopoint = geopoint
		self.notes = notes
		self.chatId = chatId
		self.imageUrl = imageUrl
		self.occurance = occurance
	}
		
	func getTime() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
	
	func getDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
	
	func image(completion: @escaping (UIImage?) -> Void) {
		UIImageView().loadImageUsingCashe(urlString: imageUrl) { (img) in
			completion(img)
		}
	}
}
