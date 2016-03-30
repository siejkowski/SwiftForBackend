//
//  HelloTests.swift
//  HelloTests
//
//  Created by Krzysztof Siejkowski on 25/03/16.
//  Copyright © 2016 Krzysztof Siejkowski. All rights reserved.
//

import XCTest
import HTTPServer
import Router
import LogMiddleware
import HTTPFile
import Mustache
@testable
import HackathonApp

class HackathonTests: XCTestCase {
    
    var router: Router?
    
    override func setUp() {
        super.setUp()
        router = createRouter()
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    func testHelloPath() {
        let response = try! router?.proceed(Request(method: .GET, uri: "/hello"))
        XCTAssertTrue(response!.bodyString!.contains("hello"))
    }
    
}
