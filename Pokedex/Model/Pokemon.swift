//
//  Pokemon.swift
//  Pokedex
//
//  Created by Isaac Gongora on 24/01/23.
//

import Foundation

class Pokemon: Decodable {
    let name: String
    let url: String
    var detail: Detail?
    
    // MARK: - Supporting types
    struct Detail: Decodable {
        let base_experience: Int
        let weight: Int
        let height: Int
        let abilities: [Abilities]
        let sprites: Sprite
        let types: [Style]
        let moves: [Move]
        let stats: [Stats]
        
        // MARK: - Supporting types
        struct Abilities: Decodable {
            let ability: NameURL
        }
        
        struct Sprite: Decodable {
            let back_default: String
            let back_shiny: String
            let front_default: String
            let front_shiny: String
        }
        
        struct Style: Decodable {
            let type: NameURL
        }
        
        struct Move: Decodable {
            let move: NameURL
        }
        
        struct Stats: Decodable {
            let base_stat: Int
            let stat: NameURL
        }
    }
    
    struct NameURL: Decodable {
        let name: String
        let url: String
    }
}
