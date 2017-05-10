//
//  OHHTTPStubSampleTests.swift
//  OHHTTPStubSampleTests
//
//  Created by Yuki Sumida on 2017/05/10.
//  Copyright © 2017年 Yuki Sumida. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import OHHTTPStubSample

class OHHTTPStubSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let testData = try! JSONSerialization.data(withJSONObject: ["id" : 1], options: [])
        let expectation = self.expectation(description: "finish")

        _ = stub(condition: isHost("hoge.com")) { _ in
            return OHHTTPStubsResponse(data: testData, statusCode: 200, headers: nil)
        }
        
        let urlString = "http://hoge.com"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if (error == nil) {
                XCTAssertTrue(testData == data!)
            }
            expectation.fulfill()
        })
        task.resume()
        
        self.waitForExpectations(timeout: 5, handler: {(error) -> Void in
            OHHTTPStubs.removeAllStubs()
            return
        })
    }
}
