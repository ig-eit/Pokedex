//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Isaac Gongora on 24/01/23.
//

import Foundation
import UIKit

class PokeAPI {
    typealias ImagesCache = NSCache<Pokemon, UIImage>
    
    let numberOfPokemons: Int = 150
    let batchSize: Int = 30
    var pokemons: [Pokemon] = []
    var nextBatch: String = "https://pokeapi.co/api/v2/pokemon?limit=30"
    var isFetchingData: Bool = false
    var imagesCache: ImagesCache = ImagesCache()
    
    func requestPokemonList(completion: @escaping([Pokemon]) -> Void) {
        guard !isFetchingData, pokemons.count < numberOfPokemons, let url = URL(string: nextBatch) else { return }
        isFetchingData = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data,
                  let pokemonBatch = try? JSONDecoder().decode(PokemonList.self, from: data)
            else { return }
            self.pokemons += pokemonBatch.results
            self.nextBatch = pokemonBatch.next
            self.isFetchingData = false
                        
            DispatchQueue.main.async {
                completion(pokemonBatch.results)
            }
        }.resume()
    }
    
    func requestPokemonDetails(pokemon: Pokemon, completion: @escaping(Pokemon.Detail) -> Void) {
        if let detail = pokemon.detail {
            completion(detail)
        }
        else {
            guard let url = URL(string: pokemon.url) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data,
                      let pokemonDetail = try? JSONDecoder().decode(Pokemon.Detail.self, from: data)
                else { return }
                pokemon.detail = pokemonDetail
                
                DispatchQueue.main.async {
                    completion(pokemonDetail)
                }
            }.resume()
        }
    }
    
    func requestSprite(for pokemon: Pokemon, completion: @escaping(UIImage) -> Void) {
        if let image = imagesCache.object(forKey: pokemon) {
            completion(image)
        }
        else {
            guard let pokemonDetail = pokemon.detail, let url = URL(string: pokemonDetail.sprites.front_default) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data,
                      let pokemonImage = UIImage(data: data)
                else { return }
                
                self.imagesCache.setObject(pokemonImage, forKey: pokemon)
                
                DispatchQueue.main.async {
                    completion(pokemonImage)
                }
            }.resume()
        }
    }
}
