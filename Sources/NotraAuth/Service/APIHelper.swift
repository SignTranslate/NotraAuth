//
//  File.swift
//  
//
//  Created by Karen Mirakyan on 28.03.24.
//

import Foundation

public class APIHelper {
    public static let shared = APIHelper()
    
    private init() { }
    
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
}
