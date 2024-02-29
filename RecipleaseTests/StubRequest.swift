//
//  URLProtocol.swift
//  RecipleaseTests
//
//  Created by Guillaume Bourlart on 10/02/2023.
//

@testable import Reciplease
import Foundation
import CoreData
import XCTest



//class MockURLProtocol: URLProtocol {
//
//    static var testData: Data?
//    static var testResponse: HTTPURLResponse?
//    static var testError: Error?
//
//    override class func canInit(with request: URLRequest) -> Bool {
//        return true
//    }
//
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//
//    override func startLoading() {
//        if let mockError = MockURLProtocol.testError {
//            self.client?.urlProtocol(self, didFailWithError: mockError)
//            return
//        }
//
//        if let mockResponse = MockURLProtocol.testResponse {
//            self.client?.urlProtocol(self, didReceive: mockResponse, cacheStoragePolicy: .notAllowed)
//        }
//
//        if let mockData = MockURLProtocol.testData {
//            self.client?.urlProtocol(self, didLoad: mockData)
//        }
//
//        self.client?.urlProtocolDidFinishLoading(self)
//    }
//
//    override func stopLoading() {}
//
//}
//


class StubRequest: NetworkRequest {
    func request(_ request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        completion(data, response, error)
    }
    
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?
    
    init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    
}




