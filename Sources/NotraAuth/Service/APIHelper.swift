//
//  File.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import Foundation
import FirebaseFunctions

public class APIHelper {
    public static let shared = APIHelper()
    
    let function: Functions
    private init() { 
        self.function = Functions.functions()
    }
    
    public func voidRequest(action: () async throws -> Void) async -> Result<Void, Error> {
        do {
            try await action()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    public func codableRequest<T: Codable>(action: () async throws -> T) async -> Result<T, Error> {
        do {
            let result = try await action()
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    public func onCallRequest<T>(params: [String: Any]? = nil,
                          name: String,
                          responseType: T.Type) async throws -> T where T : Decodable {
        
        do {
            let result = try await function.httpsCallable(name).call(params)
            print("on Call result")
            
            if let data = try? JSONSerialization.data(withJSONObject: result.data) {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                return response
            } else {
                throw CustomErrors.createErrorWithMessage("Invalid JSON data")
            }
        } catch {
            throw error
        }
        
    }
}
