//
//  RecorderHelper.swift
//  MoyaRecordable
//
//  Created by Xavier De Koninck on 14/05/2018.
//  Copyright © 2018 Xavier De Koninck. All rights reserved.
//

import Foundation
import Moya 

public struct RecorderHelper {
    
    fileprivate static let stubsDirectoryKey = "FixturesDirectoryPath"
    
    public static func read(name: String) throws -> Data {
        
        let urlStr = try url(forName: name).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        guard let url = URL(string: "file://" + urlStr) else {
            throw MoyaRecordableError.invalidURL
        }
        let data = try Data(contentsOf: url)
        return data
    }
    
    public static func write(name: String, content: String) throws {        
        let urlToRecord = try url(forName: name)
        try content.write(toFile: urlToRecord, atomically: true, encoding: .utf8)
    }
    
    static func generateName(for target: TargetType) -> String {
        return String(describing: target)
    }
    
    fileprivate static func url(forName name: String) throws -> String {
        
        let bundle = Bundle.allBundles.filter({            
            return $0.infoDictionary?[stubsDirectoryKey] != nil            
        }).first
        guard let infoPlist = bundle?.infoDictionary,
            let stubsPath = infoPlist[stubsDirectoryKey] as? String
            else { 
                throw MoyaRecordableError.fixturesDirectoryNotFound                 
        }        
        return "\(stubsPath)\(name).json"
    }
}
