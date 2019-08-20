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
}

