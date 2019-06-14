//
//  DBmanager.swift
//  passwdhldr
//
//  Created by Adam Láníček on 12/06/2019.
//  Copyright © 2019 FIT VUT. All rights reserved.
//

import UIKit
import RealmSwift
class DBManager {
    public var   database:Realm
    static let   sharedInstance = DBManager()
    private init() {
        database = try! Realm()
    }
    func getDataFromDB() ->   Results<MyPassword> {
        let results: Results<MyPassword> =   database.objects(MyPassword.self)
        return results
    }
    func addData(object: MyPassword)   {
        try! database.write {
            database.add(object, update: .all)
            print("Added new object")
        }
    }
    
    func updateData(object: MyPassword) {
        try! database.write {
            database.add(object, update: .all)
            print("An object was modified")
        }
    }
    
    func deleteAllFromDatabase()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    func deleteFromDb(object: MyPassword)   {
        try!   database.write {
            database.delete(object)
        }
    }
    
}
