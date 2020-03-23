//
//  KakaGCDQueue.swift
//  KakaGCD
//
//  Created by 李扬 on 2020/3/20.
//

import Foundation

open class KakaGCDQueue {
    
    static let kDispatchQueueSpecificKey = DispatchSpecificKey<Any>()
    
    let dispatchQueue: DispatchQueue
    
    // MARK: - init
    public init() {
        self.dispatchQueue = DispatchQueue(label: "", qos: KakaGCDQueuePriority.defaultPriority.getDispatchQoS())
        self.dispatchQueue.setSpecific(key: KakaGCDQueue.kDispatchQueueSpecificKey, value: self.dispatchQueue)
    }
    
    public init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
        self.dispatchQueue.setSpecific(key: KakaGCDQueue.kDispatchQueueSpecificKey, value: self.dispatchQueue)
    }
    
    // MARK: - main & global & high & low & backgroung
    public class var main: KakaGCDQueue {
        return KakaGCDQueue.init(dispatchQueue: DispatchQueue.main)
    }
    
    public class var global: KakaGCDQueue {
        return KakaGCDQueue.init(dispatchQueue: DispatchQueue.global(qos: KakaGCDQueuePriority.defaultPriority.getDispatchQoSClass()))
    }
    
    public class var highPriorityGlobal: KakaGCDQueue {
        return KakaGCDQueue.init(dispatchQueue: DispatchQueue.global(qos: KakaGCDQueuePriority.highPriority.getDispatchQoSClass()))
    }
    
    public class var lowPriorityGlobal: KakaGCDQueue {
        return KakaGCDQueue.init(dispatchQueue: DispatchQueue.global(qos: KakaGCDQueuePriority.lowPriority.getDispatchQoSClass()))
    }
    
    public class var backgroundPriorityGlobal: KakaGCDQueue {
        return KakaGCDQueue.init(dispatchQueue: DispatchQueue.global(qos: KakaGCDQueuePriority.backgroundPriority.getDispatchQoSClass()))
    }
    
    // MARK: - concurrentQueue & serialQueue
    public class func concurrent(_ label: String = "") -> KakaGCDQueue {
        return KakaGCDQueue.init(dispatchQueue: DispatchQueue(label: label, qos: KakaGCDQueuePriority.defaultPriority.getDispatchQoS(), attributes: .concurrent))
    }
    
    public class func serial(_ label: String = "") -> KakaGCDQueue {
        return KakaGCDQueue.init(dispatchQueue: DispatchQueue(label: label, qos: KakaGCDQueuePriority.defaultPriority.getDispatchQoS()))
    }
    
    // MARK: - excute
    public func execute(_ execute: @escaping () -> Void) {
        self.dispatchQueue.async(execute: execute)
    }
    
    public func executeAfterDelay(_ delta: Float, _ execute: @escaping () -> Void) {
        self.dispatchQueue.asyncAfter(deadline: .now() + .milliseconds(Int(delta)), execute: execute)
    }
    
    public func executeAfterDelaySecs(_ seconds: Float, _ execute: @escaping () -> Void) {
        self.dispatchQueue.asyncAfter(deadline: .now() + .milliseconds(Int(seconds * 1000)), execute: execute)
    }
    
    public func waitExecute(_ execute: @escaping () -> Void) {
        self.dispatchSync(execute)
    }
    
    // MARK: - barrier
    public func barrierExecute(_ execute: @escaping () -> Void) {
        let item = DispatchWorkItem(qos: KakaGCDQueuePriority.defaultPriority.getDispatchQoS(), flags: .barrier, block: execute)
        self.dispatchQueue.async(execute: item)
    }
    
    public func waitBarrierExecute(_ execute: @escaping () -> Void) {
        self.dispatchBarrierSync(execute)
    }
    
    // MARK: - resume & suspend
    public func suspend() {
        self.dispatchQueue.suspend()
    }
    
    public func resume() {
        self.dispatchQueue.resume()
    }
    
    // MARK: - group & notify
    public func executeInGroup(_ group: KakaGCDGroup, _ execute: @escaping () -> Void) {
        self.dispatchQueue.async(group: group.dispatchGroup, execute: execute)
    }
    
    public func notifyInGroup(_ group: KakaGCDGroup, _ execute: @escaping () -> Void) {
        group.dispatchGroup.notify(queue: self.dispatchQueue, execute: execute)
    }
    
    // MARK: - apply
    public class func applyExecute(iterations: size_t, _ execute: @escaping (Int) -> Void) {
        DispatchQueue.concurrentPerform(iterations: iterations, execute: execute)
    }
    
    // MARK: - useful execute
    public class func executeInMainAfterDelaySecs(secs: Float, _ execute: @escaping () -> Void) {
        KakaGCDQueue.main.executeAfterDelaySecs(secs, execute)
    }
    
    public class func executeInGlobalAfterDelaySecs(secs: Float, _ execute: @escaping () -> Void) {
        KakaGCDQueue.global.executeAfterDelaySecs(secs, execute)
    }
    
    public class func executeInHighAfterDelaySecs(secs: Float, _ execute: @escaping () -> Void) {
        KakaGCDQueue.highPriorityGlobal.executeAfterDelaySecs(secs, execute)
    }
    
    public class func executeInLowAfterDelaySecs(secs: Float, _ execute: @escaping () -> Void) {
        KakaGCDQueue.lowPriorityGlobal.executeAfterDelaySecs(secs, execute)
    }
    
    public class func executeInBackgroundAfterDelaySecs(secs: Float, _ execute: @escaping () -> Void) {
        KakaGCDQueue.backgroundPriorityGlobal.executeAfterDelaySecs(secs, execute)
    }
    
    public class func executeInMain(_ execute: @escaping () -> Void) {
        KakaGCDQueue.main.execute(execute)
    }
    
    public class func executeInGlobal(_ execute: @escaping () -> Void) {
        KakaGCDQueue.global.execute(execute)
    }
    
    public class func executeInHigh(_ execute: @escaping () -> Void) {
        KakaGCDQueue.highPriorityGlobal.execute(execute)
    }
    
    public class func executeInLow(_ execute: @escaping () -> Void) {
        KakaGCDQueue.lowPriorityGlobal.execute(execute)
    }
    
    public class func executeInBackground(_ execute: @escaping () -> Void) {
        KakaGCDQueue.backgroundPriorityGlobal.execute(execute)
    }
    
    // MARK: - sync
    func dispatchSync(_ execute: @escaping () -> Void)
    {
        if let _ = DispatchQueue.getSpecific(key: KakaGCDQueue.kDispatchQueueSpecificKey) {
            execute()
        } else {
            self.dispatchQueue.sync(execute: execute)
        }
    }
    
    func dispatchBarrierSync(_ execute: @escaping () -> Void) {
        if let _ = DispatchQueue.getSpecific(key: KakaGCDQueue.kDispatchQueueSpecificKey) {
            execute()
        } else {
            self.barrierExecute(execute)
        }
    }
    
    deinit {
        print("")
    }
}
