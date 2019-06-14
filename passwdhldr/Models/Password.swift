//
//  Password.swift
//  passwdhldr
//
//  Created by Adam Láníček on 09/06/2019.
//  Copyright © 2019 FIT VUT. All rights reserved.
//

import RealmSwift

class MyPassword: Object {
    @objc dynamic var id = ""
    @objc dynamic var target = ""
    @objc dynamic var login = ""
    @objc dynamic var passphrase = ""
    @objc dynamic var email = ""
    @objc dynamic var comment = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

