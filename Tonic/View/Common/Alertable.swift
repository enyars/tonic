//
//  Alertable.swift
//  Tonic
//

import Foundation
import UIKit

/// View that can show an alert view.
protocol Alertable: AnyObject {
    
    /// Shows an alert.
    func showAlert(_ alert: Alert)
}

/// Default implementation.
extension Alertable where Self: UIViewController {
    
    func showAlert(_ alert: Alert) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: alert.action.title, style: alert.action.style, handler: { _ in
            alert.actionHandler?()
        }))
        
        present(alertController, animated: true)
    }
}
