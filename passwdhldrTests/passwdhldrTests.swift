//
//  passwdhldrTests.swift
//  passwdhldrTests
//
//  Created by Adam Láníček on 09/06/2019.
//  Copyright © 2019 FIT VUT. All rights reserved.
//

import XCTest
@testable import passwdhldr

class passwdhldrTests: XCTestCase {
    
    let passwdRepo = PasswordRepository()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSaveAndGetPassword() {
        let password = passwdRepo.makeNewPassword("www.seznam.cz", login: "adam", passphrase: "heslo")
        passwdRepo.savePassword(password)
        
        let foundPassword = passwdRepo.findPasswordByTarget("www.seznam.cz")
        XCTAssertEqual(foundPassword.count, 1)
        
        let password1 = foundPassword.first
        XCTAssertEqual(password1?.login, "adam")
    }
}
