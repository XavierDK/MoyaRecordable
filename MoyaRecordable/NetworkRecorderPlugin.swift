//
//  NetworkRecorderPlugin.swift
//  MoyaRecordable
//
//  Created by Xavier De Koninck on 14/05/2018.
//  Copyright © 2018 Traveldoo. All rights reserved.
//

import Foundation
import Moya
import Result

public final class NetworkRecorderPlugin<Target>: PluginType where Target: RecordableTargetType {
        
    fileprivate let fixtures: [Fixture<Target>]
    
    public init(fixtures: [Fixture<Target>]) {
        self.fixtures = fixtures
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
                        
        if let recordFixture = fixtures.filter({ $0.target.equal(target: target) }).first {
            
            var strToRecord: String?
            switch result {
            case .failure(let error):
                strToRecord = error.failureReason                
            case .success(let response) 
                where recordFixture.statusCode == response.statusCode:                                
                strToRecord = try? response.mapString()                               
            default:
                return
            }
            
            if let strToRecord = strToRecord {
                
                let name: String
                if case let .named(n) = recordFixture.type {
                    name = n
                }  
                else if case .auto = recordFixture.type {
                    name = RecorderHelper.generateName(for: recordFixture.target)
                }
                else { return } 
                do {
                    try RecorderHelper.write(name: name, content: strToRecord)
                }
                catch {
                    print(error)
                }
            }
        }
    }
}
