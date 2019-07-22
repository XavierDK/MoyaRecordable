//
//  MoyaRecordableSpec.swift
//  MoyaRecordableTests
//
//  Created by Xavier De Koninck on 15/05/2018.
//  Copyright © 2018 Xavier De Koninck. All rights reserved.
//

import Quick
import Nimble
import Moya
import RxSwift
import RxMoya
import RxBlocking
@testable import MoyaRecordable

class MoyaRecordableSpec: QuickSpec {
    
    var networkPlayerBuilder: NetworkPlayerEndpointBuilder<GitHubAPI>!
    
    override func spec() {
        describe("the Moya recordable") {            
            
            context("if auto mode is used") {
                it("needs to be recorded and played correctely for success") {
                    let target = GitHubAPI.userProfile(name: "XavierDK")                                        
                    let fixture = Fixture(type: .auto, statusCode: 200, target: target)    
                    self.testRecording(target: target, fixtures: [fixture])
                }
                
                it("needs to be recorded and played correctely for error") {
                    let target = GitHubAPI.failableUserProfile("TEST", 42, true)                    
                    let fixture = Fixture(type: .auto, statusCode: 404, target: target)    
                    self.testRecording(target: target, fixtures: [fixture])
                }
            }
            
            context("if named mode is used") {
                it("needs to be recorded and played correctely for success") {
                    let target = GitHubAPI.userProfile(name: "XavierDK")                    
                    let fixture = Fixture(type: .named(name: "TestSuccess"), statusCode: 200, target: target)
                    self.testRecording(target: target, fixtures: [fixture])                    
                }
                it("needs to be recorded and played correctely for error") {
                    let target = GitHubAPI.failableUserProfile("TEST", 42, true)                    
                    let fixture = Fixture(type: .named(name: "TestError"), statusCode: 404, target: target)
                    self.testRecording(target: target, fixtures: [fixture])                    
                }
            }
        }
    }
    
    fileprivate func testRecording(target: GitHubAPI, fixtures: [Fixture<GitHubAPI>]) {
        
        let providerRecorder = MoyaProvider<GitHubAPI>(plugins: [NetworkRecorderPlugin(fixtures: fixtures)])
        let stringRecorded = try! providerRecorder.rx.request(target)
            .mapString()
            .toBlocking()
            .first()
        
        networkPlayerBuilder = NetworkPlayerEndpointBuilder(fixtures: fixtures)
        let providerPlayer = MoyaProvider<GitHubAPI>(endpointClosure: networkPlayerBuilder.endpoint, stubClosure: { _ in .immediate })
        let stringRead = try! providerPlayer.rx.request(target)
            .mapString()
            .toBlocking()
            .first()
        
        expect(stringRecorded).to(equal(stringRead))
    } 
}
