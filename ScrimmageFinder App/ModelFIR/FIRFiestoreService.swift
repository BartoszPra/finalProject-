//
import Foundation
import Firebase
import FirebaseFirestore

// CRUD operations for forebase
class FIRFirestoreService {
	
	enum UploadType {
		case userProfile
		case scrimmageImage
	}
	
	var listener: ListenerRegistration?
    
    private init() {}
    static let shared = FIRFirestoreService()
        
    func configure() {
        FirebaseApp.configure()
    }
  //collection reference
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    private func filesReference() -> Storage {
        return Storage.storage()
    }
	
	func removeListener() {
		listener?.remove()
	}
        
    // create function exluding id it will be added automatically by fireabase
	func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference, completion: @escaping (Bool) -> Void) -> String {
		do {
            let json = try encodableObject.toJson(excluding: ["id"])
			let ref = reference(to: collectionReference).addDocument(data: json) { (error) in
				if let e = error {
					print("Error saving channel: \(e.localizedDescription)")
					completion(false)
				} else {
					completion(true)
				}
			}
			return ref.documentID
        } catch {
            print(error)
			return ""
        }
    }
   
    // read function exluding id it will be added automatically by fireabase to pull data from firebase
    func readAll<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        listener = reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
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
        
        listener = reference(to: collectionReference).whereField(whereFld, isEqualTo: equalsTo).addSnapshotListener { (snapshot, _) in
		
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
    
    func readWhereArray<T: Decodable>(from collectionReference: FIRCollectionReference, whereArray: String, contains: String, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        listener = reference(to: collectionReference).whereField(whereArray, arrayContains: contains).addSnapshotListener { (snapshot, error) in
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
				print(error?.localizedDescription as Any)
            }
        }
    }
   
   // update function inclding id to update record in firebase - not using it yet maybe in future
	func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference, completion: @escaping (Bool) -> Void) {
        
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let oId = encodableObject.id else { throw MyError.encodingError }
            reference(to: collectionReference).document(oId).setData(json)
			reference(to: collectionReference).document(oId).setData(json) { (err) in
				if err != nil {
					completion(false)
				} else {
					completion(true)
				}
			}
            
        } catch {
			print(error)
			completion(false)
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
        listener = reference(to: collectionReference).document(id).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                let object = try snapshot.decode(as: objectType.self)
                completion(object)                
            } catch {
                print(error)
            }
        }
    }
	
	func removeFromParticipantsTable(for scrimmageID: String, with userId: String, status: ParticipantsStatus, participants: [String: ParticipantsStatus], completion: @escaping (Bool) -> Void) {
        
		let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
		var participantWOme = participants
		participantWOme.removeValue(forKey: userId)
		
		currentScrimmage.updateData(["participants": participantWOme]) { (error) in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
            } else {
                print("succesfully removed from participants")
                completion(true)
            }
        }
    }
	
	func updateScrimmageImageURL(for scrimmageID: String, url: String, completion: @escaping (Bool) -> Void) {
		let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
		
		currentScrimmage.updateData(["imageUrl": url]) { (error) in
			if let err = error {
				print(err.localizedDescription)
				completion (false)
			} else {
				print("succesfully added new url")
				completion (true)
			}
		}
	}
	
	func updateParticipantsTable(for scrimmageID: String, for userId: String, with status: Int, completion: @escaping (Bool) -> Void) {
		let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
		
		currentScrimmage.updateData(["participants": [userId: status]]) { (error) in
			if let err = error {
				print(err.localizedDescription)
				completion (false)
			} else {
				print("succesfully added to participants")
				completion (true)
			}
		}
	}
    
	func addToParticipantsTable(for scrimmageID: String, with userId: String, status: Int, completion: @escaping (Bool) -> Void) {
		let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
		currentScrimmage.updateData(["participants": [userId : status]]) { (error) in
			if let err = error {
				print(err.localizedDescription)
				completion (false)
			} else {
				print("succesfully updated participants")
				completion (true)
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
    
    func updateSavedTable(for scrimmageID: String, with userId: String, completion: @escaping (Bool) -> Void) {
        var isSuccesful = false
        let currentScrimmage = reference(to: .scrimmages).document(scrimmageID)
        currentScrimmage.updateData(["savedById": FieldValue.arrayUnion([userId])]) { (error) in
            if let err = error {
                print(err.localizedDescription)
                isSuccesful = false
                completion(isSuccesful)
            } else {
                print("succesfully added to saved")
                isSuccesful = true
                completion(isSuccesful)
            }
        }
    }
	
	func getScrimmageImage(for scrimmageId: String, completion: @escaping (UIImage) -> Void) {
        
		var image = UIImage(named: "imageJordan")
		
        let imageReference = "ScrimmageImage/" + scrimmageId + ".jpg"
        let ref = filesReference().reference().child(imageReference)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("No uploaded image for this scrimmage" + error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
			image = UIImage(data: data!)
            completion(image!)
          }
        }
    }
    
    func getProfileImage(for user: String, completion: @escaping (UIImage) -> Void) {
        
        let imageReference = "ProfileImage/" + user + ".jpg"
        let ref = filesReference().reference().child(imageReference)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("User didn't upload image" + error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
            guard let image = UIImage(data: data!) else {return}
            completion(image)
          }
        }
    }
	
	func deleteImage(_ url: String, completion: @escaping (Bool) -> Void) {
		
		let storageRef = filesReference().reference(forURL: url)
		storageRef.delete { (err) in
			if let error = err {
				print(error.localizedDescription)
				completion(false)
			} else {
				completion(true)
			}
		}
	}
	
	func replaceImage(newImage: UIImage, url: String, completion: @escaping(URL?) -> Void){
		
		guard let scaledImage = newImage.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
			completion(nil)
			return
		}
		
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"
		
		let storageRef = filesReference().reference(forURL: url)
		
		storageRef.putData(data, metadata: metadata) { metaData, error in
			if error == nil, metaData != nil {
				storageRef.downloadURL { (url, err) in
					completion(url)
				}
			} else {
				// failed
				completion(nil)
			}
		}
		
	}
	
	func uploadImage(_ image: UIImage, folderName: String, completion: @escaping (URL?) -> Void) {

		guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
			completion(nil)
			return
		}

		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"

		let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
		
		let storageRef = filesReference().reference().child(folderName).child(imageName)
		
		storageRef.putData(data, metadata: metadata) { metaData, error in
			if error == nil, metaData != nil {
				storageRef.downloadURL { url, error in
					completion(url)
					// success!
				}
			} else {
				// failed
				completion(nil)
			}
		}
	}
    
	func uploadImage(image: UIImage, uploadType: UploadType, for scrimmageId: String, for userId: String, success: @escaping (Bool) -> Void) {
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        guard let uploadImageData = image.jpegData(compressionQuality: 0.5) else {return}
		var childReference: String!
        
		// Upload file and metadata to the object 'images/mountains.jpg'
		if uploadType == .userProfile {
			childReference = "ProfileImage/" + userId + ".jpg"
		} else if uploadType == .scrimmageImage {
			childReference = "ScrimmageImage/" + scrimmageId + ".jpg"
		}
		
        let uploadTask = filesReference().reference().child(childReference).putData(uploadImageData, metadata: metadata) { (data, error) in
            guard let data = data else {
                print("there was an error uploading" + error!.localizedDescription)
                success(false)
              return
            }
            success(true)
            print(data)
        }

        uploadTask.observe(.progress) { snapshot in
          // Upload reported progress
          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
          print(String(percentComplete) + "% upload complete")
        }

        uploadTask.observe(.success) { snapshot in
          print("Your profile has been uploaded")
            // Upload completed successfully
        }

        uploadTask.observe(.failure) { snapshot in
          if let error = snapshot.error as? NSError {
            switch (StorageErrorCode(rawValue: error.code)!) {
            case .objectNotFound:
              // File doesn't exist
              break
            case .unauthorized:
              // User doesn't have permission to access file
              break
            case .cancelled:
              // User canceled the upload
              break
            case .unknown:
              // Unknown error occurred, inspect the server response
              break
            default:
              // A separate error occurred. This is a good place to retry the upload.
              break
            }
          }
        }
    }    
}
