//
//  KakaGCDConst.swift
//  KakaGCD
//
//  Created by 李扬 on 2020/3/23.
//

import Foundation

enum KakaGCDQueuePriority {
    case backgroundPriority // DISPATCH_QUEUE_PRIORITY_BACKGROUND
    case lowPriority // DISPATCH_QUEUE_PRIORITY_LOW
    case defaultPriority // DISPATCH_QUEUE_PRIORITY_DEFAULT
    case highPriority // DISPATCH_QUEUE_PRIORITY_HIGH
    
    case userInteractive
    case unspecified
    
    func getDispatchQoSClass() -> DispatchQoS.QoSClass {
        var qos: DispatchQoS.QoSClass
        
        switch self {
            
        case KakaGCDQueuePriority.backgroundPriority:
            qos = .background
            break
            
        case KakaGCDQueuePriority.lowPriority:
            qos = .utility
            break
            
        case KakaGCDQueuePriority.defaultPriority:
            qos = .default
            break
            
        case KakaGCDQueuePriority.highPriority:
            qos = .userInitiated
            break
            
        case KakaGCDQueuePriority.userInteractive:
            qos = .userInteractive
            break
            
        case KakaGCDQueuePriority.unspecified:
            qos = .unspecified
            break
        }
        
        return qos
    }
    
    func getDispatchQoS() -> DispatchQoS {
        var qos: DispatchQoS
        
        switch self {
            
        case KakaGCDQueuePriority.backgroundPriority:
            qos = .background
            break
            
        case KakaGCDQueuePriority.lowPriority:
            qos = .utility
            break
            
        case KakaGCDQueuePriority.defaultPriority:
            qos = .default
            break
            
        case KakaGCDQueuePriority.highPriority:
            qos = .userInitiated
            break
            
        case KakaGCDQueuePriority.userInteractive:
            qos = .userInteractive
            break
            
        case KakaGCDQueuePriority.unspecified:
            qos = .unspecified
            break
        }
        
        return qos
    }
}
