//
//  KakaLifeFreedomThread.swift
//  KakaGCD
//
//  Created by 李扬 on 2020/3/23.
//

import Foundation

class KakaThread: Thread {
    deinit {
        print("KakaThread deinit")
    }
}

@available(iOS 10, *)
public class KakaLifeFreedomThread: NSObject {
    
    static let kLifeFreedomThreadSpecificKey = DispatchSpecificKey<Any>()
    
    var innerThread: KakaThread?
    
    public override init() {
        self.innerThread = KakaThread.init(block: {
            // 创建上下文（要初始化一下结构体）
            var context: CFRunLoopSourceContext = CFRunLoopSourceContext()
            
            // 创建source
            let source: CFRunLoopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context)
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, CFRunLoopMode.defaultMode);
            
            // 启动
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 1.0e10, false);
        })
        self.innerThread?.start()
    }
    
    @objc public func syncExecute(_ execute: @escaping () -> Void) {
        if let t = self.innerThread {
            if Thread.current == t {
                execute()
            } else {
                self.perform(#selector(syncExecute(_:)), on: t, with: execute, waitUntilDone: true)
            }
        }
    }
    
    @objc public func asyncExecute(_ execute: @escaping () -> Void) {
        if let t = self.innerThread {
            self.perform(#selector(syncExecute(_:)), on: t, with: execute, waitUntilDone: false)
        }
    }
    
    public func stop() {
        if let t = self.innerThread {
            self.perform(#selector(__stop), on: t, with: nil, waitUntilDone: true)
        }
    }
    
    // MARK: - private method
    @objc func __stop() {
        CFRunLoopStop(CFRunLoopGetCurrent())
        self.innerThread = nil
    }
    
    deinit {
        self.stop()
    }
}
