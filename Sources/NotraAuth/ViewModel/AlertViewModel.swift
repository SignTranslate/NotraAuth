//
//  File.swift
//
//
//  Created by Karen Mirakyan on 28.03.24.
//

import Foundation
public class AlertViewModel {
    
    public init() { }
    
    public func makeAlert(with error: Error, message: inout String, alert: inout Bool ) {
        message = error.localizedDescription
        alert.toggle()
    }
}
