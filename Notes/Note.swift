//
//  Note.swift
//  Notes
//
//  Created by Daniyar Merekeyev on 02.04.2023.
//

import Foundation

class Note: NSObject {
    var title: String
    var text: String
    var time: String
    
    init(title: String, text: String, time: String) {
        self.title = title
        self.text = text
        self.time = time
    }
    
    static var notes = [Note]()
}

public func dateFormatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: date)
}
