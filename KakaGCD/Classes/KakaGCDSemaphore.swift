//
//  KakaGCDSemaphore.swift
//  KakaGCD
//
//  Created by 李扬 on 2020/3/23.
//

import Foundation

public class KakaGCDSemaphore {
    let dispatchSemaphore: DispatchSemaphore
    
    public init(initialSignal: Int = 0) {
        self.dispatchSemaphore = DispatchSemaphore(value: initialSignal)
    }
    
    public func signal() {
        self.dispatchSemaphore.signal()
    }
    
    public func wait() {
        self.dispatchSemaphore.wait()
    }
    
    public func waitForDelta(_ delta: Float) -> DispatchTimeoutResult {
        self.dispatchSemaphore.wait(timeout: .now() + .milliseconds(Int(delta)))
    }
}
