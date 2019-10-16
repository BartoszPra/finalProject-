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
    
    func readWhereArray<T: Decodable>(from collectionReference: FIRCollectionReference, whereArray: String, contains: Any, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).whereField(whereArray, arrayContains: contains).addSnapshotListener { (snapshot, _) in
            
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
    
    func updateSavedTable(for scrimmageID: String, with userId: String) {
        
        let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
        
        currentScrimmage.updateData(["savedById": FieldValue.arrayUnion([userId])])
    }
}
