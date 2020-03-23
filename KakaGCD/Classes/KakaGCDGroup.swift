//
//  KakaGCDGroup.swift
//  KakaGCD
//
//  Created by 李扬 on 2020/3/23.
//

import Foundation

public class KakaGCDGroup {
    public let dispatchGroup: DispatchGroup
    
    public init() {
        self.dispatchGroup = DispatchGroup()
    }
    
    public func enter() {
        self.dispatchGroup.enter()
    }
    
    public func leave() {
        self.dispatchGroup.leave()
    }
    
    public func wait() {
        self.dispatchGroup.wait()
    }
    
    public func waitForDelta(_ delta: Float) -> DispatchTimeoutResult {
        self.dispatchGroup.wait(timeout: .now() + .milliseconds(Int(delta)))
    }
}
