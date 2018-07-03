//
//  Fixture.swift
//  MoyaRecordable
//
//  Created by Xavier De Koninck on 14/05/2018.
//  Copyright © 2018 Traveldoo. All rights reserved.
//

import Foundation
import Moya

public struct Fixture<Target> where Target: RecordableTargetType {
    
    public let type: FixtureType
    public let statusCode: Int
    public let target: Target
    
    public init(type: FixtureType, statusCode: Int, target: Target) {
        self.type = type
        self.statusCode = statusCode
        self.target = target
    }
}

public enum FixtureType {
    
    case auto
    case named(name: String)
}
