//
//  CocktailsUI.swift
//  Tonic
//

import Foundation
import UIKit

/// Enum used for namespace.
enum CocktailsUI {}

/// Contains all the UI elements for cocktails controller.
extension CocktailsUI {
    
    /// The cocktails list table view.
    static var cocktailsTableView: UITableView {
        let tableView = UITableView()
        
        tableView.register(CocktailsListCell.self, forCellReuseIdentifier: CocktailsListCell.reuseIdentifier)
        
        tableView.separatorStyle = .none
        
        return tableView
    }
    
    /// The reload button (if cocktails list has no elements).
    static func reloadButton(target: UIViewController, action: Selector) -> UIButton {
        let button = UIButton()
                        
        let text = NSMutableAttributedString(
            string: NSLocalizedString("cocktails.reload.button", comment: ""),
            attributes: [
                .font: UIFont.cocktailMediumWithSize(size: 20),
                .foregroundColor: UIColor.label,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        
        button.setAttributedTitle(text, for: .normal)
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return button
    }
}
