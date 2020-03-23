//
//  KakaGCDTimer.swift
//  KakaGCD
//
//  Created by 李扬 on 2020/3/23.
//

import Foundation

public class KakaGCDTimer {
    
    var isSuspend: Bool
    
    let dispatchSourceTimer: DispatchSourceTimer
    
    public init(in: KakaGCDQueue, interval: Float, delta: Float) {
        self.isSuspend = true // 默认创建的timer都是挂起的
        self.dispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: `in`.dispatchQueue)
        self.dispatchSourceTimer.schedule(deadline: .now() + .milliseconds(Int(delta)), repeating: .milliseconds(Int(interval)))
    }
    
    public convenience init(in: KakaGCDQueue, interval: Float) {
        self.init(in: `in`, interval: interval, delta: 0)
    }
    
    public convenience init(in: KakaGCDQueue, intervalSecs interval: Float) {
        self.init(in: `in`, interval: interval * 1000, delta: 0)
    }
    
    public convenience init(in: KakaGCDQueue, intervalSecs interval: Float, delaySecs delta: Float) {
        self.init(in: `in`, interval: interval * 1000, delta: delta * 1000)
    }
    
    public func setTimerEventHandler(eventHandler: @escaping (KakaGCDTimer)-> Void) {
        self.dispatchSourceTimer.setEventHandler {
            eventHandler(self)
        }
    }
    
    // resume 必须从 挂起中 恢复
    public func resume() {
        if self.isSuspend == true {
            self.dispatchSourceTimer.resume()
            self.isSuspend = false
        }
    }
    
    // suspend 必须从 恢复中 挂起
    public func suspend() {
        if self.isSuspend == false {
            self.dispatchSourceTimer.suspend()
            self.isSuspend = true
        }
        
    }
    
    // cancel 必须从 resume 状态下取消
    public func destroy() {
        self.resume()
        self.dispatchSourceTimer.cancel()
    }
    
    deinit {
        print("")
    }
}

