//
//  StringExtensions.swift
//  
//
//  Created by Reid Nantes on 2019-08-19.
//

import Foundation

extension String {
    func subscring(after afterIndex: String.Index, numberOfCharacters: Int) -> String {
        let lastIndex = self.index(afterIndex, offsetBy: numberOfCharacters)
        if lastIndex < self.endIndex {
            return String(self[afterIndex...lastIndex])
        } else {
            return String(self[afterIndex...self.endIndex])
        }
    }

    func encompassesIndex(_ index: String.Index) -> Bool {
        if (index < self.endIndex) {
            return true
        }

        return false
    }

    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }

        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            return true
        }

        return false
    }
}
