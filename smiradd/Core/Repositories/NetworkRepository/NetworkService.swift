import os.log
import Foundation
import SwiftUI

let isProd = true

class NetworkService: INetworkService {
    private let baseUrl = "http\(isProd ? "s" : "")://\(isProd ? "smiradd.ru" : "80.90.185.153:5002")/api/"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    func post(url: String, body: [String: Any], completion: @escaping (Result<[String: Any], ErrorModel>) -> Void) {
        request(method: "POST", url: url, body: body, completion: completion)
    }
    
    func get(url: String, completion: @escaping (Result<[String: Any], ErrorModel>) -> Void) {
        request(method: "GET", url: url, body: nil, completion: completion)
    }
    
    func delete(url: String, completion: @escaping (Result<[String: Any], ErrorModel>) -> Void) {
        request(method: "DELETE", url: url, body: nil, completion: completion)
    }
    
    func patch(url: String, body: [String: Any], completion: @escaping (Result<[String: Any], ErrorModel>) -> Void) {
        request(method: "PATCH", url: url, body: body, completion: completion)
    }
    
    private func request(method: String, url: String, body: [String: Any]?, completion: @escaping (Result<[String: Any], ErrorModel>) -> Void) {
        let accessToken = self.accessToken ?? ""
        
        let fullUrl = URL(string: "\(baseUrl)\(url)")!
        var request = URLRequest(url: fullUrl)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        var requestData: Data? = nil
        if let body = body {
            requestData = try! JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        self.logRequest(
            method: method,
            url: url,
            data: requestData
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(ErrorModel(statusCode: 500, message: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ErrorModel(statusCode: 500, message: "Invalid response")))
                return
            }
            
            self.logResponse(
                statusCode: httpResponse.statusCode,
                data: data,
                method: method,
                url: url
            )
            
            switch httpResponse.statusCode {
            case 200:
                if let data = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = jsonObject as? [String: Any] {
                            completion(.success(jsonDict))
                        } else if let jsonArray = jsonObject as? [[String: Any]] {
                            completion(.success(["payload": jsonArray]))
                        } else {
                            completion(.failure(ErrorModel(statusCode: 500, message: "Invalid JSON response")))
                        }
                    } catch {
                        completion(.failure(ErrorModel(statusCode: 500, message: "JSON deserialization error: \(error.localizedDescription)")))
                    }
                } else {
                    completion(.failure(ErrorModel(statusCode: 500, message: "No data received")))
                }
            case 401:
                self.refresh { result in
                    switch result {
                    case .success:
                        self.request(method: method, url: url, body: body, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            default:
                let message = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(ErrorModel(statusCode: httpResponse.statusCode, message: message)))
            }
        }
        
        task.resume()
    }
    
    func refresh(completion: @escaping (Result<Void, ErrorModel>) -> Void) {
        guard let refreshToken = self.refreshToken else {
            completion(.failure(ErrorModel(statusCode: 401, message: "No refresh token")))
            return
        }
        
        let fullUrl = URL(string: "\(baseUrl)refresh")!
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        self.logRequest(
            method: "POST",
            url: "refresh",
            data: nil
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(ErrorModel(statusCode: 500, message: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ErrorModel(statusCode: 500, message: "Invalid response")))
                return
            }
            
            self.logResponse(
                statusCode: httpResponse.statusCode,
                data: data,
                method: "POST",
                url: "refresh"
            )
            
            if httpResponse.statusCode == 200 {
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let payload = json["payload"] as? [String: Any],
                   let newAccessToken = payload["access_token"] as? String,
                   let newRefreshToken = payload["refresh_token"] as? String {
                    UserDefaults.standard.set(newAccessToken, forKey: "accessToken")
                    UserDefaults.standard.set(newRefreshToken, forKey: "refreshToken")
                    completion(.success(()))
                } else {
                    completion(.failure(ErrorModel(statusCode: 500, message: "Invalid JSON response")))
                }
            } else {
                let message = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(ErrorModel(statusCode: httpResponse.statusCode, message: message)))
            }
        }
        
        task.resume()
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<Void, ErrorModel>) -> Void) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let url = URL(string: "https://vizme.pro/api/storage")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let httpBody = NSMutableData()
            httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
            httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            httpBody.append(imageData)
            httpBody.append("\r\n".data(using: .utf8)!)
            httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = httpBody as Data
            
            self.logRequest(
                method: "POST",
                url: "https://vizme.pro/api/storage",
                data: nil
            )
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error {
                    completion(.failure(ErrorModel(statusCode: 500, message: error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(ErrorModel(statusCode: 500, message: "Invalid response")))
                    return
                }
                
                self.logResponse(
                    statusCode: httpResponse.statusCode,
                    data: data,
                    method: "POST",
                    url: "https://vizme.pro/api/storage"
                )
                
                if httpResponse.statusCode == 200 {
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let payload = json["payload"] as? [String: Any],
                       let newAccessToken = payload["access_token"] as? String,
                       let newRefreshToken = payload["refresh_token"] as? String {
                        UserDefaults.standard.set(newAccessToken, forKey: "accessToken")
                        UserDefaults.standard.set(newRefreshToken, forKey: "refreshToken")
                        completion(.success(()))
                    } else {
                        completion(.failure(ErrorModel(statusCode: 500, message: "Invalid JSON response")))
                    }
                } else {
                    let message = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                    completion(.failure(ErrorModel(statusCode: httpResponse.statusCode, message: message)))
                }
            }
            
            task.resume()
        } else {
            print("Failed to convert UIImage to Data")
        }
    }
    
    private func logRequest(method: String, url: String, data: Data?) {
        let requestBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "No body"
        logger.notice(
            """
            Request:
                Method: \(method)
                URL: \(self.baseUrl)\(url)
                \(data == nil ? "" : "Body: \(data!.prettyPrintedJSONString)")
            """
        )
    }
    
    private func logResponse(statusCode: Int, data: Data?, method: String, url: String) {
        let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "No body"
        if statusCode == 200 {
            logger.info(
                """
                Response:
                    Method: \(method)
                    URL: \(self.baseUrl)\(url)
                    Status Code: \(statusCode)
                    Body: \(data!.prettyPrintedJSONString)
                """
            )
        }
        else if statusCode == 401 {
            logger.warning(
                """
                Response:
                    Method: \(method)
                    URL: \(self.baseUrl)\(url)
                    Status Code: \(statusCode)
                    Body: \(data!.prettyPrintedJSONString)
                """
            )
        }
        else {
            logger.fault(
                """
                Response:
                    Method: \(method)
                    URL: \(self.baseUrl)\(url)
                    Status Code: \(statusCode)
                    Body: \(data!.prettyPrintedJSONString)
                """
            )
        }
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
