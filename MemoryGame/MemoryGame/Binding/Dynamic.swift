//
//  Dynamic.swift
//  MemoryGame
//
//  Created by Alex Ch on 18.01.25.
//

import Foundation

class Dynamic<Generic> {
    var value: Generic {
        didSet {
            DispatchQueue.main.async {
                for listener in self.listeners {
                    listener(self.value)
                }
            }
        }
    }
    
    init(_ value: Generic) {
        self.value = value
    }
    
    private var listeners = [(Generic) -> Void]()
    
    func bind(_ listener: @escaping (Generic) -> Void) {
        listener(value)
        self.listeners.append(listener)
    }
}
