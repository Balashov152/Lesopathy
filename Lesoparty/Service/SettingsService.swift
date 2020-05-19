//
//  SettingsService.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 27.04.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import Foundation

extension Storage {
    enum SettingsKeys: String {
        case intensityNotification
    }
    
    static var intensityType: SettingsModel.TypeIntensity? {
        get {
            return SettingsModel.TypeIntensity(rawValue: defaults.integer(forKey: SettingsKeys.intensityNotification.rawValue))
        } set {
            defaults.set(newValue?.rawValue, forKey: SettingsKeys.intensityNotification.rawValue)
            defaults.synchronize()
        }
    }
}

struct SettingsModel {
    enum TypeIntensity: Int, CaseIterable {
        case often, average, rarely
        
        var title: String {
            return "\(self)"
        }
    }
}

class SettingsService {
    
    var intensityType: SettingsModel.TypeIntensity {
        get {
            return Storage.intensityType ?? .often
        } set {
            Storage.intensityType = newValue
        }
        
    }
}
