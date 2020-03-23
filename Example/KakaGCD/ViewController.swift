//
//  ViewController.swift
//  KakaGCD
//
//  Created by 403760530@qq.com on 03/20/2020.
//  Copyright (c) 2020 403760530@qq.com. All rights reserved.
//

import UIKit
import KakaGCD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.testQueueDelay()
        
//        self.testTimer()
        
//        self.testLifeFreedomThread()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func testQueueDelay() -> Void {
        print("🔥 1")
        KakaGCDQueue.executeInGlobalAfterDelaySecs(secs: 5) {
            print("🔥 2 - \(Thread.current)")
        }
    }
    
    func testTimer() {
        print("🔥 1")
        let timer = KakaGCDTimer.init(in: KakaGCDQueue.global, intervalSecs: 3, delaySecs: 3)
        timer.setTimerEventHandler { _ in
            print("🔥 4")
        }
        
        timer.resume()
        
        KakaGCDQueue.executeInMainAfterDelaySecs(secs: 10) {
            print("🔥 5")
            timer.suspend()
            print("🔥 6")
            KakaGCDQueue.executeInGlobalAfterDelaySecs(secs: 5) {
                print("🔥 7")
                timer.resume()
                print("🔥 8")
            }
        }
    }
    
//    func testLifeFreedomThread() {
//        let lifeFreedomThread = KakaLifeFreedomThread()
//        lifeFreedomThread.asyncExecute {
//            print("❄️ a")
//        }
//
//        KakaGCDQueue.executeInGlobalAfterDelaySecs(secs: 3.0) {
//            lifeFreedomThread.syncExecute {
//                print("❄️ a")
//
//                lifeFreedomThread.syncExecute {
//                    print("❄️ b")
//                }
//            }
//
//            KakaGCDQueue.executeInMainAfterDelaySecs(secs: 1.0) {
//                lifeFreedomThread.stop()
//
//                KakaGCDQueue.executeInGlobalAfterDelaySecs(secs: 2.0) {
//                    lifeFreedomThread.syncExecute {
//                        print("❄️ c")
//                    }
//                }
//            }
//        }
//    }
}

