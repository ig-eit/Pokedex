//
//  PokemonList.swift
//  Pokedex
//
//  Created by Isaac Gongora on 24/01/23.
//

import Foundation

struct PokemonList: Decodable {
    let next: String
    let results: [Pokemon]
}
