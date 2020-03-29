//
//  ChatViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {
	
	private var isSendingPhoto = false	
	private let db = Firestore.firestore()
	private var reference: CollectionReference?
	private let storage = Storage.storage().reference()	
	private var messages: [Message] = []
	private var messageListener: ListenerRegistration?
	var currentUserString = Auth.auth().currentUser?.displayName
	let user: User
	private let channel: Chat
	var theTitle = ""
	var chatImage = UIImage(named: "logoNoBackgroundBrighter")
	
	deinit {
		messageListener?.remove()
	}
	
	init(user: User, channel: Chat) {
		self.user = user
		self.channel = channel
		super.init(nibName: nil, bundle: nil)
		title = channel.returnChatsName(with: currentUserString!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createNavtitle()
		
		if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
			layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
			layout.textMessageSizeCalculator.incomingAvatarSize = .zero
			layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
			layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
			
		}
		
		guard let id = channel.id else {
			navigationController?.popViewController(animated: true)
			return
		}
		
		reference = db.collection(["chats", id, "messages"].joined(separator: "/"))		
		messageListener = reference?.addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
				return
			}
			
			snapshot.documentChanges.forEach { change in
				self.handleDocumentChange(change)
			}
		}
		
		navigationItem.largeTitleDisplayMode = .never
		
		maintainPositionOnKeyboardFrameChanged = true
		messageInputBar.inputTextView.tintColor = UIColor.black
		messageInputBar.inputTextView.textColor = .white
		messageInputBar.sendButton.setTitleColor(UIColor.white, for: .normal)
		messageInputBar.inputTextView.keyboardAppearance = .dark
		
		messageInputBar.delegate = self
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messagesCollectionView.backgroundColor = .black
		messageInputBar.backgroundView.backgroundColor = .black
		
		let cameraItem = InputBarButtonItem(type: .system) // 1
		cameraItem.tintColor = .primary
		cameraItem.image = #imageLiteral(resourceName: "camera")
		cameraItem.addTarget(
		      self,
		      action: #selector(cameraButtonPressed), // 2
		      for: .primaryActionTriggered
		    )
		    cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
		
		messageInputBar.leftStackView.alignment = .center
		messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
		messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false) // 3
		//self.messagesCollectionView.scrollToBottom()
		self.messagesCollectionView.scrollToLastItem()
	}

	func createNavtitle() {
		let navView = UIView()

		// Create the label
		let label = UILabel()
		label.text = theTitle
		label.sizeToFit()
		label.center = navView.center
		label.textColor = .white
		label.textAlignment = NSTextAlignment.center

		// Create the image view
		let image = UIImageView()
		image.image = chatImage
		// To maintain the image's aspect ratio:
		let imageAspect = image.image!.size.width/image.image!.size.height
		// Setting the image frame so that it's immediately before the text:
		image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
		image.contentMode = UIView.ContentMode.scaleAspectFit

		// Add both the label and image view to the navView
		navView.addSubview(label)
		navView.addSubview(image)

		// Set the navigation bar's navigation item's titleView to the navView
		self.navigationItem.titleView = navView

		// Set the navView's frame to fit within the titleView
		navView.sizeToFit()
	}
	
	func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
		avatarView.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc private func cameraButtonPressed() {
		let picker = UIImagePickerController()
		picker.delegate = self
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		} else {
			picker.sourceType = .photoLibrary
		}
		
		present(picker, animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	private func save(_ message: Message) {
		reference?.addDocument(data: message.representation) { error in
			if let e = error {
				print("Error sending message: \(e.localizedDescription)")
				return
			}
			self.messagesCollectionView.scrollToBottom()
		}
	}
	
	private func insertNewMessage(_ message: Message) {
	  guard !messages.contains(message) else {
		return
	  }

	  messages.append(message)
	  messages.sort()

	  let isLatestMessage = messages.index(of: message) == (messages.count - 1)
	  let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage

	  messagesCollectionView.reloadData()

	  if shouldScrollToBottom {
		DispatchQueue.main.async {
			//self.messagesCollectionView.scrollToBottom(animated: true)
			self.messagesCollectionView.scrollToLastItem()
		}
	  }
	}
	
//	func insertNewMessage(_ message: Message) {
//        messages.append(message)
//
//        // Reload last section to update header/footer labels and insert a new one
//        messagesCollectionView.performBatchUpdates({
//            messagesCollectionView.insertSections([messages.count - 1])
//            if messages.count >= 2 {
//                messagesCollectionView.reloadSections([messages.count - 2])
//            }
//        }, completion: { [weak self] _ in
//            if self?.isLastSectionVisible() == true {
//                self?.messagesCollectionView.scrollToBottom(animated: true)
//            }
//        })
//    }
	
	func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
	
	private func handleDocumentChange(_ change: DocumentChange) {
		guard var message = Message(document: change.document) else {
			return
		}
		
		switch change.type {
		case .added:
			if let url = message.downloadURL {
				downloadImage(at: url) { [weak self] image in
					guard let `self` = self else {
						return
					}
					guard let image = image else {
						return
					}
					
					message.image = image
					self.insertNewMessage(message)
				}
			} else {
				insertNewMessage(message)
			}
			
		default:
			break
		}
	}
	
	private func uploadImage(_ image: UIImage, to channel: Chat, completion: @escaping (URL?) -> Void) {
		guard let channelID = channel.id else {
			completion(nil)
			return
		}

		guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
			completion(nil)
			return
		}

		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"

		let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
		
		let storageRef = storage.child(channelID).child(imageName)
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
	
	  private func sendPhoto(_ image: UIImage) {
	    isSendingPhoto = true
	
	    uploadImage(image, to: channel) { [weak self] url in
	      guard let `self` = self else {
	        return
	      }
	      self.isSendingPhoto = false
	
	      guard let url = url else {
	        return
	      }
	
	      var message = Message(user: self.user, image: image)
	      message.downloadURL = url
	
	      self.save(message)
	      self.messagesCollectionView.scrollToBottom()
	    }
	  }
	
	private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
		let ref = Storage.storage().reference(forURL: url.absoluteString)
		let megaByte = Int64(1 * 1024 * 1024)
		
		ref.getData(maxSize: megaByte) { data, error in
			guard let imageData = data else {
				completion(nil)
				return
			}
			
			completion(UIImage(data: imageData))
		}
	}
	
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
	
	func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ? .primary : .incomingMessage
	}
	
	func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
		return true
	}
	
	func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
		let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
		return .bubbleTail(corner, .curved)
	}
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
	
	func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
		return CGSize(width: 0, height: 8)
	}
	
	func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		
		return 0
	}
	
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
	
	func currentSender() -> SenderType {
		return Sender(senderId: user.id!, displayName: user.userName)
	}
	
	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	
	func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	
	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}
	
	func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 10.0
	}
	
	func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		let name = message.sender.displayName
		return NSAttributedString(
			string: name,
			attributes: [
				.font: UIFont.preferredFont(forTextStyle: .caption1),
				.foregroundColor: UIColor(white: 0.3, alpha: 1)
			]
		)
	}
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
	
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		let message = Message(user: user, content: text)
		
		save(message)
		inputBar.inputTextView.text = ""
	}
}

// MARK: - UIImagePickerControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		
		if let asset = info[.phAsset] as? PHAsset { // 1
			let size = CGSize(width: 500, height: 500)
			PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
				guard let image = result else {
					return
				}
				
				self.sendPhoto(image)
			}
		} else if let image = info[.originalImage] as? UIImage { // 2
			sendPhoto(image)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
}
