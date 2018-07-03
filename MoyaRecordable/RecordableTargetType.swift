//
//  RecordableTargetType.swift
//  Alamofire
//
//  Created by Xavier De Koninck on 06/06/2018.
//

import Foundation
import Moya

public protocol RecordableTargetType: TargetType {
    var realTarget: RecordableTargetType? { get } 
    func equal(target: TargetType) -> Bool
} 

extension TargetType {
    public var realTarget: RecordableTargetType? { 
        return self as? RecordableTargetType
    }
}

extension MultiTarget: RecordableTargetType {
    public var realTarget: RecordableTargetType? { 
        return target as? RecordableTargetType
    }
    
    public func equal(target: TargetType) -> Bool {
        if let target = target as? RecordableTargetType,
            let realTarget = target.realTarget {
            return self.realTarget?.equal(target: realTarget) ?? false
        }
        return false
    }
}
