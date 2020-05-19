//
//  Colors.swift
//  SellFashion
//
//  Created by Sergey Balashov on 02/08/2019.
//  Copyright © 2019 Sellfashion. All rights reserved.
//

import UIKit

extension UIColor {
    // new colors
    static let moderateRed = UIColor(named: "moderateRed") ?? .red
    /// purple
    static let appPurple = UIColor(named: "appPurple") ?? .purple
    /// orange
    static let appOrange = UIColor(named: "appOrange") ?? .orange
    /// orange
    static let appGreen = UIColor(named: "appGreen") ?? .green

    /// badgeColor
    static let badgeColor = UIColor(named: "badgeColor") ?? .red

    /// red
    static let appRed = UIColor(red: 1.0, green: 0.21, blue: 0.22, alpha: 1.0)

    /// white
    static let gray255 = UIColor(named: "gray255") ?? UIColor.white

    /// 247 / 255 or 0.97
    static let gray247 = UIColor(named: "gray247") ?? UIColor(white: 247 / 255, alpha: 1)

    /// 243 / 255  or 0.95
    static let gray243 = UIColor(named: "gray243") ?? UIColor(white: 243 / 255, alpha: 1)

    /// 225 / 255 or 0.88
    static let gray225 = UIColor(named: "gray225") ?? UIColor(white: 225 / 255, alpha: 1)

    /// 192 / 255 or 0.75
    static let gray192 = UIColor(named: "gray192") ?? UIColor(white: 192 / 255, alpha: 1)

    /// 174 / 255  or 0.68
    static let gray174 = UIColor(named: "gray174") ?? UIColor(white: 174 / 255, alpha: 1)

    /// 34 / 255 or 0.13
    static let gray34 = UIColor(named: "gray34") ?? UIColor(white: 34 / 255, alpha: 1)

    /// black
    static let gray0 = UIColor(named: "gray0") ?? UIColor.black
}

extension UIColor {
    class func color(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return .gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
}
