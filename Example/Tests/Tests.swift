import XCTest
import KakaGCD

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQueueConcurrent() -> Void {
        let concurrentQueue = KakaGCDQueue.concurrent()
        concurrentQueue.execute {
            for i in 0...10 {
                print("🔥 \(i)")
            }
        }
        
        concurrentQueue.execute {
            for i in 0...10 {
                print("❄️ \(i)")
            }
        }
    }
    
    func testQueueSerial() -> Void {
        let serialQueue = KakaGCDQueue.serial()
        serialQueue.execute {
            for i in 0...10 {
                print("🔥 \(i)")
            }
        }
        
        serialQueue.execute {
            for i in 0...10 {
                print("❄️ \(i)")
            }
        }
    }
    
    func testQueueDelay() -> Void {
        print("🔥 1")
        KakaGCDQueue.executeInMainAfterDelaySecs(secs: 5, {
            print("🔥 2")
        })
    }
    
    func testQueueWaitExecute() -> Void {
        let queue = KakaGCDQueue.concurrent()
        queue.waitExecute {
            print("🔥 1")
            queue.waitExecute {
                print("🔥 3")
            }
        }
        queue.waitExecute {
            print("🔥 2")
        }
    }
    
    func testBarrier() -> Void {
        let queue = KakaGCDQueue.concurrent()
        
        queue.execute {
            print("🔥 1")
        }
        
        queue.execute {
            print("🔥 2")
        }
        
        queue.execute {
            print("🔥 3")
        }
        
        queue.barrierExecute {
             print("❄️ a")
        }
        
        queue.execute {
            print("🔥 4")
        }
        
        queue.execute {
            print("🔥 5")
        }
        
        queue.execute {
            print("🔥 6")
        }
    }
    
    func testwWaitBarrier() -> Void {
        let queue = KakaGCDQueue.concurrent()
        
        queue.execute {
            print("🔥 1")
        }
        
        queue.execute {
            print("🔥 2")
        }
        
        queue.execute {
            print("🔥 3")
        }
        
        queue.waitBarrierExecute {
            print("❄️ a")
            queue.waitBarrierExecute {
                 print("❄️ b")
            }
        }
        
        queue.execute {
            print("🔥 4")
        }
        
        queue.waitBarrierExecute {
             print("❄️ c")
        }
        
        queue.execute {
            print("🔥 5")
        }
        
        queue.execute {
            print("🔥 6")
        }
    }
    
    func testGroupNotify() {
        let group = KakaGCDGroup()
        KakaGCDQueue.global.executeInGroup(group) {
            print("1")
        }
        
        KakaGCDQueue.global.executeInGroup(group) {
            print("2")
        }
        
        KakaGCDQueue.main.executeInGroup(group) {
            print("3")
        }
        
        KakaGCDQueue.global.executeInGroup(group) {
            print("4")
        }
        
        KakaGCDQueue.main.notifyInGroup(group) {
            print("结束")
        }
    }
    
    func testApplyExecute() {
        let from: NSString = "/Users/liyang/Desktop/From";
        let to: NSString = "/Users/liyang/Desktop/To";
        
        let manager: FileManager = FileManager.default
        if let subPathsArr = manager.subpaths(atPath: from as String) {
            KakaGCDQueue.applyExecute(iterations:subPathsArr.count) { (index) in
                let subPath = subPathsArr[index]
                let fromFullPath = from.appendingPathComponent(subPath)
                let toFullPath = to.appendingPathComponent(subPath)
                do {
                    try manager.moveItem(atPath: fromFullPath, toPath: toFullPath)
                } catch let error {
                    print(error)
                }
                print("index \(Thread.current)")
            }
        } else {
            fatalError("严重错误")
        }
    }
    
    func testUsefulQueue() {
        print("🔥 1")
        KakaGCDQueue.executeInMain {
            print("🔥 2 - \(Thread.current)")
        }
    }
    
    func testSemaphore() {
        print("🔥 1")
        let semaphore = KakaGCDSemaphore.init()
        KakaGCDQueue.global.execute {
            print("🔥 2")
            semaphore.wait()
            print("🔥 3")
        }
        
        KakaGCDQueue.executeInLowAfterDelaySecs(secs: 5, {
            print("🔥 4")
            semaphore.signal()
        })
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
}
