import SwiftUI

func makeRequest<Model: Codable>(
    path: String,
    method: HTTPMethod,
    body: Data? = nil,
    isString: Bool = false,
    completion: @escaping (Result<Model, Error>) -> Void,
    isProd: Bool = true
) {
    
    let url = URL(string: "http\(isProd ? "s" : "")://\(isProd ? "smiradd.ru/" : "80.90.185.153:5002")/api/\(path)")!
    
    print("Request url: \(url.absoluteString):")
    print("type: \(method)")
    
    if body != nil {
        print("body: \(body!.prettyPrintedJSONString() ?? "")")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    let accessToken = UserDefaults.standard.string(forKey: path.contains("refresh") ? "refresh_token" : "access_token")
    
    print("accessToken: \(accessToken!)")
    
    if let token = accessToken {
        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )
    }
    
    if let requestData = body {
        request.httpBody = requestData
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        let httpResponse = response as? HTTPURLResponse
        print("Response url: \(url.absoluteString):")
        print("status code: \(httpResponse!.statusCode)")
        
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(URLError(.dataNotAllowed)))
            return
        }
        
        if let json = data.prettyPrintedJSONString() {
            print("body:\n\(json)")
        } else {
            let string = String(data: data, encoding: .utf8)
            print("Unable to decode data as JSON. Response data as String:\n\(string ?? "nil")")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if httpResponse?.statusCode == 401 && !path.contains("refresh") {
                makeRequest(
                    path: "auth/refresh-token",
                    method: .post
                ) { (result: Result<AuthorizationModel, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let authorizationModel):
                            UserDefaults.standard.set(
                                authorizationModel.access_token,
                                forKey: "access_token"
                            )
                            UserDefaults.standard.set(
                                authorizationModel.refresh_token,
                                forKey: "refresh_token"
                            )
                            makeRequest(
                                path: path,
                                method: method,
                                body: body,
                                completion: completion
                            )
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
            if httpResponse?.statusCode == 400 || httpResponse?.statusCode == 423 {
                completion(.success([] as! Model))
            }
            else {
                completion(.failure(URLError(.badServerResponse)))
            }
            return
        }
        
        do {
            if isString {
                let string = String(data: data, encoding: .utf8)
                completion(.success(DeleteModel(text: string ?? "") as! Model))
            }
            else {
                let decodedData = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(decodedData))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

func uploadImageToServer<Model: Codable>(image: Image, completion: @escaping (Result<Model, Error>) -> Void) {
    let uiImage = image.asUIImage()
    
    if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Model.self, from: data!)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    } else {
        print("Failed to convert UIImage to Data")
    }
}

func uploadUIImageToServer<Model: Codable>(image: UIImage, completion: @escaping (Result<Model, Error>) -> Void) {
    let uiImage = image
    
    if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Model.self, from: data!)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    } else {
        print("Failed to convert UIImage to Data")
    }
}

extension View {
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    // This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension Data {
    func prettyPrintedJSONString() -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        
        return prettyPrintedString
    }
}
