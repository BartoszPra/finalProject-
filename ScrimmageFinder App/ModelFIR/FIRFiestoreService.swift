//
import Foundation
import Firebase
import FirebaseFirestore

// CRUD operations for forebase
class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
        
    func configure() {
        FirebaseApp.configure()
    }
  //collection reference
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    private func filesReference(url:String) -> Storage{
        return Storage.storage(url: url)
    }
        
    // create function exluding id it will be added automatically by fireabase
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            reference(to: collectionReference).addDocument(data: json)
            
        } catch {
            print(error)
        }
    }
   
    // read function exluding id it will be added automatically by fireabase to pull data from firebase
    func readAll<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            do {
                
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                
                completion(objects)
                
            } catch {
                print(error)
            }
        }
        
    }
    
    func readWhere<T: Decodable>(from collectionReference: FIRCollectionReference, whereFld: String, equalsTo: Any, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).whereField(whereFld, isEqualTo: equalsTo).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            do {
                
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                
                completion(objects)
                
            } catch {
                print(error)
            }
        }
        
    }
    
    func deleteFromSavedBy(for scrimmageID: String, with userId: String) -> Bool {
        
        var boolToReturn = false
        let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
        currentScrimmage.updateData(["savedById": FieldValue.arrayRemove([userId])]) { (error) in
            if let err = error {
                print(err.localizedDescription)
                boolToReturn = false
            } else {
                print("scrimmage unsaved")
                boolToReturn = true
            }
        }
        return boolToReturn
    }
    
    func readWhereArray<T: Decodable>(from collectionReference: FIRCollectionReference, whereArray: String, contains: String, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).whereField(whereArray, arrayContains: contains).addSnapshotListener { (snapshot, error) in
            if error == nil {
                guard let snapshot = snapshot else { return }
                do {
                    var objects = [T]()
                    for document in snapshot.documents {
                        let object = try document.decode(as: objectType.self)
                        objects.append(object)
                    }
                    
                    completion(objects)
                    
                } catch {
                    print(error)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
   
   // update function inclding id  to update record in firebase - not using it yet maybe in future
    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let oId = encodableObject.id else { throw MyError.encodingError }
            reference(to: collectionReference).document(oId).setData(json)
            
        } catch {
            print(error)
        }
    }
    // delete function inclding id to delete records in firebase -  using it only when testing to easy delete dummy data
    func delete<T: Identifiable>(_ identifiableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            guard let oId = identifiableObject.id else { throw MyError.encodingError }
            reference(to: collectionReference).document(oId).delete()
            
        } catch {
            print(error)
        }
    }
    
    func updateChild<T: Identifiable>(_ identifiableObject: T, collection: FIRCollectionReference) {
        
        do {
            guard let oId = identifiableObject.id else { throw MyError.encodingError }
            reference(to: collection).document(oId).updateData([
                Auth.auth().currentUser!.uid: Auth.auth().currentUser!.uid])
        } catch {
            print(error)
        }
        
    }
    
    func readOne<T: Decodable>(from collectionReference: FIRCollectionReference, with id: String, returning objectType: T.Type, completion: @escaping (T) -> Void) {
        
        reference(to: collectionReference).document(id).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            do {
                let object = try snapshot.decode(as: objectType.self)
                completion(object)
                
            } catch {
                print(error)
            }
        }
        
    }
    
    func addToParticipantsTable(for scrimmageID: String, with userId: String, status: Int, completion: @escaping (Bool) -> Void) {
        var isSuccesful = false
        let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
        currentScrimmage.updateData(["participants": FieldValue.arrayUnion([[userId: status]])]) { (error) in
        if let err = error {
            print(err.localizedDescription)
            isSuccesful = false
            completion (isSuccesful)
        } else {
            print("succesfully added to participants")
            isSuccesful = true
            completion (isSuccesful)
        }
        }
    }
    
    func removeFromParticipantsTable(for scrimmageID: String, with userId: String, status: ParticipantsStatus, completion: @escaping (Bool) -> Void) {
        var isSuccesful = false
        let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
        
        currentScrimmage.updateData(["participants": FieldValue.arrayRemove([[userId: status]])]) { (error) in
            if let err = error {
                print(err.localizedDescription)
                isSuccesful = false
                completion(isSuccesful)
            } else {
                print("succesfully removed from participants")
                isSuccesful = true
                completion(isSuccesful)
            }
        }
    }
    
    func updateSavedTable(for scrimmageID: String, with userId: String, completion: @escaping (Bool) -> Void) {
        var isSuccesful = false
        let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
        currentScrimmage.updateData(["savedById": FieldValue.arrayUnion([userId])]) { (error) in
            if let err = error {
                print(err.localizedDescription)
                isSuccesful = false
                completion(isSuccesful)
            } else {
                print("succesfully removed from participants")
                isSuccesful = true
                completion(isSuccesful)
            }
        }
    }
}
