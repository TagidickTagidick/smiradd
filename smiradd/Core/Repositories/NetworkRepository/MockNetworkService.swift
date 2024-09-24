import Foundation
import SwiftUI

class MockNetworkService: INetworkService {
    
    func put(url: String, body: [String : Any]?, completion: @escaping (Result<[String : Any], ErrorModel>) -> Void) {
        
    }
    
    func uploadImage(
        image: UIImage,
        completion: @escaping (Result<String, ErrorModel>) -> Void
    ) {
        
    }
    
    
    private let mockResponse: [String: Any]

    init(mockResponse: [String: Any]) {
        self.mockResponse = mockResponse
    }

    func post(
        url: String,
        body: [String: Any]?,
        completion: @escaping (Result<[String: Any], ErrorModel>) -> Void
    ) {
        // Implement if needed
    }

    func get(
        url: String,
        completion: @escaping (Result<[String: Any], ErrorModel>) -> Void
    ) {
        completion(.success(mockResponse))
    }

    func delete(
        url: String,
        completion: @escaping (Result<[String: Any], ErrorModel>) -> Void
    ) {
        // Implement if needed
    }

    func patch(
        url: String,
        body: [String: Any?]?,
        completion: @escaping (Result<[String: Any], ErrorModel>) -> Void
    ) {
        // Implement if needed
    }
    
    func refresh(completion: @escaping (Result<Void, ErrorModel>) -> Void) {
        
    }

    // Add other necessary methods if needed
}
