//
//  RecipeServiceTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Bourlart on 31/01/2023.
//

@testable import Reciplease
import XCTest
import Foundation
import CoreData
import UIKit
import OHHTTPStubs

class RecipeServiceTests: XCTestCase {
    
    var recipeService: RecipeService!
    var image: UIImage!
    var url: URL!
       
       override func setUp() {
           super.setUp()
           
           self.recipeService = RecipeService(service: Service(networkRequest: StubRequest(data: nil, response: nil, error: nil)))
           url = URL(string: "https://api.edamam.com/api/recipes/v2")!
       }
       
       override func tearDown() {
           image = nil
           url = nil
           super.tearDown()
       }
    
    //TESTS RECIPES
    //SUCCESS
    func testGivenIngredientsAreAvailable_WhenRequestingRecipesAndResponseIsValidAndDataIsValidAndErrorIsNil_ThenResultIsNotNilAndErrorIsNil() {
        //Ingredients
        let ingredients = ["apple", "banana"]
        //DATA
        let bundle = Bundle(for: RecipeServiceTests.self)
        let url = bundle.url(forResource: "data", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        //RESPONSE
        let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        //ERROR
        let error: Error? = nil
        
        let expectedResult = try! JSONDecoder().decode(Recipes.self, from: data) // Replace with your expected result
        
        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)
        
        // Act
        let expectation = self.expectation(description: "wait for result")
        recipeService.getRecipes(availableIngredients: ingredients, link: nil) { result, error in
            // Assert
            XCTAssertEqual(result, expectedResult)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testGivenLinkIsAvailable_WhenRequestingRecipesAndResponseIsValidAndDataIsValidAndErrorIsNil_ThenResultIsNotNilAndErrorIsNil(){
        //Ingredients
        let link = "https://api.edamam.com/api/recipes/v2?q=egg&app_key=9b714c18b1141015cb3299c458486542&_cont=CHcVQBtNNQphDmgVQntAEX4BYlZtAgsFQGJIBWAQalNxAAMFUXlSUWpHYFZ6VwUARDAWAzMQYFB2UQcORmYUUTFCNVF3AlYVLnlSVSBMPkd5DAMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=f9e36a00"
        //DATA
        let bundle = Bundle(for: RecipeServiceTests.self)
        let url = bundle.url(forResource: "data", withExtension: "json")
        let data: Data? = try! Data(contentsOf: url!)
        //RESPONSE
        let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        //ERROR
        let error: Error? = nil // Replace with your expected result
        
        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)
        
        // Act
        let expectation = self.expectation(description: "wait for result")
        recipeService.getRecipes(availableIngredients: nil, link: link) { result, error in
            // Assert
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    


    //ERRORS

    func testGivenIngredientsAreAvailable_WhenRequestingRecipesAndResponseIsValidAndDataIsInvalidAndErrorIsNil_ThenResultIsNilAndErrorIsNotNil(){
        //Ingredients
        let ingredients = ["apple", "banana"]
        //DATA
        let bundle = Bundle(for: RecipeServiceTests.self)
        let url = bundle.url(forResource: "data", withExtension: "json")
        let data: Data? = nil
        //RESPONSE
        let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        //ERROR
        let error: Error? = nil // Replace with your expected result
        
        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)
        
        // Act
        let expectation = self.expectation(description: "wait for result")
        recipeService.getRecipes(availableIngredients: ingredients, link: nil) { result, error in
            // Assert
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    func testGivenIngredientsAreAvailable_WhenRequestingRecipesAndResponseIsInvalidAndDataIsValidAndErrorIsNil_ThenResultIsNilAndErrorIsNotNil(){
        //Ingredients
        let ingredients = ["apple", "banana"]
        //DATA
        let bundle = Bundle(for: RecipeServiceTests.self)
        let url = bundle.url(forResource: "data", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        //RESPONSE
        let response = HTTPURLResponse(url: url!, statusCode: 500, httpVersion: nil, headerFields: nil)
        //ERROR
        let error: Error? = nil
        
        let expectedResult = try! JSONDecoder().decode(Recipes.self, from: data) // Replace with your expected result
        print(expectedResult)
        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)
        
        // Act
        let expectation = self.expectation(description: "wait for result")
        recipeService.getRecipes(availableIngredients: ingredients, link: nil) { result, error in
            // Assert
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
}

    func testGivenIngredientsAreAvailable_WhenRequestingRecipesAndResponseIsValidAndDataValidAndErrorIsNotNil_ThenResultIsNilAndErrorIsNotNil(){
        //Ingredients
        let ingredients = ["apple", "banana"]
        //DATA
        let bundle = Bundle(for: RecipeServiceTests.self)
        let url = bundle.url(forResource: "data", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        //RESPONSE
        let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        //ERROR
        class FakeError: Error {}
        let error: Error? = FakeError()
        
        let expectedResult = try! JSONDecoder().decode(Recipes.self, from: data) // Replace with your expected result
        print(expectedResult)
        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)
        
        // Act
        let expectation = self.expectation(description: "wait for result")
        recipeService.getRecipes(availableIngredients: ingredients, link: nil) { result, error in
            // Assert
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }


//    //TESTS IMAGE
//
//    //SUCCESS
    func testGivenUrlISValid_WhenRequestingImageAndResponseIsValidAndDataIsValidAndErrorIsNil_ThenResultIsNotNilAndErrorIsNil() {
            //URL
            let urlString = "https://www.example.com/image.png"
            let url = URL(string: urlString)!
            //DATA
            let image = UIImage(named: "testImage.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let imageData = image!.pngData()
            let data = imageData
            //RESPONSE
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            //ERROR
            let error: Error? = nil

            recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)

            let expectation = self.expectation(description: "Image should be returned")
            recipeService.getImage(urlString: urlString) { (image, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(image)
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1, handler: nil)

    }
    
    

//    //ERRORS

    func testGivenUrlISValid_WhenRequestingImageAndResponseIsValidAndDataIsInvalidAndErrorIsNil_ThenResultIsNilAndErrorIsNotNil(){
        
        //URL
        let urlString = "https://www.example.com/image.png"
        let url = URL(string: urlString)!
        //DATA
        let image = UIImage(named: "testImage.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        _ = image!.pngData()
        let data: Data? = nil
        //RESPONSE
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //ERROR
        let error: Error? = nil
        
        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)
        
        let expectation = self.expectation(description: "Image should be returned")
        recipeService.getImage(urlString: urlString) { (image, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGivenUrlISValid_WhenRequestingImageAndResponseIsInvalidAndDataIsValidAndErrorIsNil_ThenResultIsNilAndErrorIsNotNil(){

        //URL
        let urlString = "https://www.example.com/image.png"
        let url = URL(string: urlString)!
        //DATA
        let image = UIImage(named: "testImage.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imageData = image!.pngData()
        let data = imageData
        //RESPONSE
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        //ERROR
        let error: Error? = nil

        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)

        let expectation = self.expectation(description: "Image should be returned")
        recipeService.getImage(urlString: urlString) { (image, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(image)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGivenUrlISValid_WhenRequestingImageAndResponseIsValidAndDataIsValidAndErrorIsNotNil_ThenResultIsNilAndErrorIsNotNil(){

        //URL
        let urlString = "https://www.example.com/image.png"
        let url = URL(string: urlString)!
        //DATA
        let image = UIImage(named: "testImage.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imageData = image!.pngData()
        let data = imageData
        //RESPONSE
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        //ERROR
        class FakeError: Error {}
        let error: Error? = FakeError()

        recipeService.service.networkRequest = StubRequest(data: data, response: response, error: error)

        let expectation = self.expectation(description: "Image should be returned")
        recipeService.getImage(urlString: urlString) { (image, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(image)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
