//
//  Interactor.swift
//  Tonic
//

import Foundation

protocol Interactor: AnyObject {
    
    // Gets called when interactor can load it's state (ex. viewDidLoad).
    func load()
    
    // Gets called when interactor can refresh it's state (ex. viewDidAppear).
    func refresh()
}

// Make these functions optional.
extension Interactor {
    func refresh() {}
}

