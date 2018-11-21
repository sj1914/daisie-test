//
//  ios_exerciseUITests.swift
//  ios-exerciseUITests
//
//  Created by Chris Bond on 22/10/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import XCTest

class ios_exerciseUITests: XCTestCase {
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        app = XCUIApplication()

        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.terminate()
    }
    
    func testPullToRefresh() {
        let transactionTable = app.tables.matching(identifier: "transactionView")
        let cell = transactionTable.cells.element(matching: .cell, identifier: "myCell_0_0")

        let start = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
        start.press(forDuration: 0, thenDragTo: finish)
    }
    
    func testDetailedTransactionViewShown() {
        app.launch()
        
        XCTAssertTrue(app.isDisplayingHomeView)
        
        let transactionTable = app.tables.matching(identifier: "transactionView")
        let cell = transactionTable.cells.element(matching: .cell, identifier: "myCell_0_0")
        
        cell.tap()
    
        XCTAssertTrue(app.isDisplayingDetailedTransactionView)
        
    }
    
    func testAddMoneyViewShown() {
        app.launch()
        
        app.buttons["Card"].tap()
        
        XCTAssertTrue(app.isDisplayingCardView)
        
        app.buttons["AddMoneyButton"].tap()
        
        XCTAssertTrue(app.isDisplayingAddMoneyView)

    }
    
    func testIncreaseButtonAddsMoney() {
        
    }
    
}

extension XCUIApplication {
    var isDisplayingDetailedTransactionView: Bool {
        return otherElements["DetailedTransactionView"].exists
    }
    
    var isDisplayingAddMoneyView: Bool {
        return otherElements["AddMoneyView"].exists
    }
    
    var isDisplayingCardView: Bool {
        return otherElements["CardView"].exists
    }
    
    var isDisplayingHomeView: Bool {
        return otherElements["HomeView"].exists
    }
}
