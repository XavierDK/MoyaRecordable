//
//  GithubAPIService.swift
//  MoyaRecordableTests
//
//  Created by Xavier De Koninck on 14/05/2018.
//  Copyright © 2018 Traveldoo. All rights reserved.
//

import Foundation
import Moya
import MoyaRecordable

enum GitHubAPI: Equatable, RecordableTargetType {
    
    case userProfile(name: String)    
    case failableUserProfile(String, Int, Bool)        
}

extension GitHubAPI {
    
    func equal(target: TargetType) -> Bool {
        
        if let target = target as? GitHubAPI {
            return target == self
        }
        return false
    }    
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path: String {        
        switch self {
        case .userProfile(let name):
            return "/users/\(name.URLEscapedString)"        
        case .failableUserProfile:
            return "/users/." // There is no user with name ., so we will get 404 for our stub
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userProfile:
            return .get
        case .failableUserProfile:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
