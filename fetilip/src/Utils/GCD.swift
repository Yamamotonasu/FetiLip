//
//  GCD.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/21.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation

/// Grand Central Dispatch
struct GCD {

    enum `Type` {
        // async
        case async(queue: GCD.Queue)
        // sync
        case sync(queue: GCD.Queue)
        // after
        case after(second: Double, queue: GCD.Queue)
    }

    // priority
    enum QOS {
        case main
        case background
    }

    // queue
    enum Queue {
        // main thread
        case main
        // global thread
        case global(priority: GCD.QOS)

        var value: DispatchQueue {
            switch self {
            // return main
            case .main:
                return DispatchQueue.main
            case .global(let qos):
                switch qos {
                case .main:
                    return DispatchQueue.main
                case .background:
                    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
                }
            }
        }
    }

    static func run(_ type: Type, _ block: @escaping () -> Void) {
        switch type {
        case .async(let queue):
            queue.value.async {
                block()
            }
        case .sync(let queue):
            queue.value.sync {
                block()
            }
        case .after(let second, let queue):
            queue.value.asyncAfter(deadline: self.dispatchTime(second)) {
                block()
            }
        }
    }

    // return processing time
    fileprivate static func dispatchTime(_ second: Double) -> DispatchTime {
        return DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }

}
