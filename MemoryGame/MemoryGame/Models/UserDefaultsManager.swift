//
//  UserDefaultsManager.swift
//  MemoryGame
//
//  Created by Alex Ch on 3.02.25.
//

import Foundation

final class UserDefaultsManager {
    static var shared = UserDefaultsManager()
    private init() {}
    
    func getVibroEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "vibro")
    }
    
    func getSoundEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "sound")
    }
    
    func setVibro() {
        UserDefaults.standard.set(!getVibroEnabled(), forKey: "vibro")
    }
    
    func setSound() {
        UserDefaults.standard.set(!getSoundEnabled(), forKey: "sound")
    }
}
