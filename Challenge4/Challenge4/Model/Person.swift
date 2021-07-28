//
//  Person.swift
//  Challenge4
//
//  Created by Ed Yama on 28/07/21.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
