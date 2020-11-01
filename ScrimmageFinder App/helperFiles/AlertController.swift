import UIKit

class AlertController {
    static func showAllert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action  = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
	
	static func showOkAllertWothChandler(_ inViewController: UIViewController, title: String, message: String, handler: @escaping (UIAlertAction) -> Void) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action  = UIAlertAction(title: "OK", style: .default, handler: handler)
		alert.addAction(action)
		inViewController.present(alert, animated: true, completion: nil)
	}
}
