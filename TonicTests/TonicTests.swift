//
//  TonicTests.swift
//  TonicTests
//
//  Created by Enea Mihaj on 2022-08-18.
//

import XCTest
@testable import Tonic

class TonicTests: XCTestCase {
    
    private let service = CocktailNetworkService()

    func testCocktailService() throws {
        let expectation = XCTestExpectation(description: "Reload database.")
        
        service.getCocktails { result in
            switch result {
            case .success(let cocktails):
                cocktails.forEach { cocktail in
                    XCTAssertNotNil(cocktail.id)
                    XCTAssertNotNil(cocktail.name)
                    XCTAssertNotNil(cocktail.imageUrl)
                }
                
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
