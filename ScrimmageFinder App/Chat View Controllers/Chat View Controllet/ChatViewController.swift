//
//  ChatViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseFirestore
import Firebase

class ChatViewController: MessagesViewController, MessagesDisplayDelegate, MessagesLayoutDelegate {
	
	private var messages: [MessageType] = []
	private var messageListener: ListenerRegistration?
    var id: String
	var user = Auth.auth().currentUser!
	var userId = Auth.auth().currentUser!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		messageInputBar.delegate = self
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self

    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, chatId: String) {
		self.id = chatId
		super.init(nibName: nil, bundle: nil)
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
	
	private func insertNewMessage(_ message: MessageType) {
		guard !messages.contains(where: message as! (MessageType) throws -> Bool) else {
		return
	  }
	  
	  messages.append(message)
	  messages.sort()
	  
	  let isLatestMessage = messages.index(of: message) == (messages.count - 1)
	  let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
	  
	  messagesCollectionView.reloadData()
	  
	  if shouldScrollToBottom {
		DispatchQueue.main.async {
		  self.messagesCollectionView.scrollToBottom(animated: true)
		}
	  }
	}
}

extension ChatViewController: MessageInputBarDelegate {
  
  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    let message = Message(user: user, content: text)

    save(message)
    inputBar.inputTextView.text = ""
  }
  
}

extension ChatViewController: MessagesDataSource {
	
	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return 1
	}
	
	func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	

  // 1
  func currentSender() -> SenderType {
	return Sender(id: user.uid, displayName: user.displayName!)
  }

  // 3
  func messageForItem(at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> MessageType {

    return messages[indexPath.section]
  }

  // 4
  func cellTopLabelAttributedText(for message: MessageType,
    at indexPath: IndexPath) -> NSAttributedString? {

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
