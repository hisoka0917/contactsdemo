//
//  Contact.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/12.
//  Copyright © 2018 github. All rights reserved.
//

import Foundation

struct Contact: Codable {
    var first_name: String
    var last_name: String
    var avatar_filename: String
    var title: String
    var introduction: String
}
