//
//  StorageTest.swift
//  LogicTests
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import XCTest

class StorageTest: XCTestCase {

    let storage = UserDefaults.standard
    
    override func setUp() {
        super.setUp()
        storage.cityIDs = []
    }

    // clean up and make sure user default is restored
    override func tearDown() {
        super.tearDown()
        storage.cityIDs = []
    }

    func testIds() {
        let ids = [1,2,3]
        storage.cityIDs = ids
        XCTAssertEqual(storage.cityIDs.count, 3)
        
        storage.cityIDs = [1,2,3,4]
        XCTAssertEqual(storage.cityIDs.count, 4)
    }

    func testAddId() {
        let id = 43
        storage.appendCityId(id: id)
        
        XCTAssertEqual(storage.cityIDs.count, 1)
        XCTAssertEqual(storage.cityIDs.last!, id)
    }
    
    func testRemoveId() {
        let ids = [1,2,3]
        storage.cityIDs = ids
        
        let idToRemove = 2
        storage.removeCityId(id: idToRemove)
        
        XCTAssertEqual(storage.cityIDs.count, 2)
        XCTAssertEqual(storage.cityIDs.last!, 3)
        XCTAssertEqual(storage.cityIDs.first!, 1)
        
        // remove an none exist id
        storage.removeCityId(id: idToRemove)
        XCTAssertEqual(storage.cityIDs.count, 2)
        XCTAssertEqual(storage.cityIDs.last!, 3)
        XCTAssertEqual(storage.cityIDs.first!, 1)
    }
}
