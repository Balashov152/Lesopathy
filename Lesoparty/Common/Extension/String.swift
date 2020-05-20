//
//  String.swift
//  Lesoparty
//
//  Created by Sergey Balashov on 19.05.2020.
//  Copyright © 2020 Sergey Balashov. All rights reserved.
//

import UIKit

extension String {
    var isCorrectWord: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
}
