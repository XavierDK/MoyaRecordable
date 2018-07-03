//
//  NetworkPlayerEndpointBuilder.swift
//  MoyaRecordable
//
//  Created by Xavier De Koninck on 14/05/2018.
//  Copyright © 2018 Traveldoo. All rights reserved.
//

import Foundation
import Moya
import Result

public final class NetworkPlayerEndpointBuilder<Target> where Target: RecordableTargetType {
    
    fileprivate let fixtures: [Fixture<Target>]
    
    public init(fixtures: [Fixture<Target>]) {    
        self.fixtures = fixtures
    }
    
    public func endpoint(for target: Target) -> Endpoint {
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { [weak self] in
                
                if let recordFixture = self?.fixtures
                    .filter({                        
                        return target.equal(target: $0.target)                         
                    })
                    .first,                    
                    case let .named(name: name) = recordFixture.type,
                    let data = try? RecorderHelper.read(name: name) {
                    return .networkResponse(recordFixture.statusCode, data)                                              
                }
                else if let recordFixture = self?.fixtures
                    .filter({ 
                        return target.equal(target: $0.target)                         
                    })
                    .first,                     
                    case .auto = recordFixture.type,                    
                    let data = try? RecorderHelper.read(name: RecorderHelper.generateName(for: recordFixture.target)) {
                    return .networkResponse(recordFixture.statusCode, data)                                              
                }
                else {
                    return .networkResponse(200, target.sampleData)
                }
            },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }       
}
