//
//  CharacterExtensions.swift
//  
//
//  Created by Reid Nantes on 2019-09-11.
//

import Foundation

extension Character {
    func isEqualToOneOf(characters: [Character]) -> Bool {
        for aCharacter in characters {
            if self == aCharacter {
                return true
            }
        }

        return false
    }

    func isNotEqualToOneOf(characters: [Character]) -> Bool {
        return !self.isEqualToOneOf(characters: characters)
    }
}
