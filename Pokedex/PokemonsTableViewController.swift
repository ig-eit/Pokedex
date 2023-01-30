//
//  PokemonsTableViewController.swift
//  Pokedex
//
//  Created by Isaac Gongora on 24/01/23.
//

import UIKit

class PokemonsTableViewController: UITableViewController {
    let pokeAPI: PokeAPI = PokeAPI()
    var pokemons: [Pokemon] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tintColor: UIColor = .systemYellow
        let fontSize: CGFloat = 25
        let font: UIFont = UIFont(name: "Pokemon Solid", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .medium)
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: tintColor, .font: font]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = tintColor
        //navigationController?.navigationBar.topItem?.title = "Pokedex"
        
        let imageView: UIImageView = UIImageView(image: UIImage(named: "pokemon_logo"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonCell

        let pokemon: Pokemon = pokemons[indexPath.row]
        cell.pokemonImageView.image = nil
        cell.nameLabel.text = pokemon.name.capitalized
        cell.activityIndicatorView.startAnimating()
        
        pokeAPI.requestPokemonDetails(pokemon: pokemon) { detail in
            self.pokeAPI.requestSprite(for: pokemon) { image in
                cell.pokemonImageView.image = image
                cell.activityIndicatorView.stopAnimating()
            }
            
            let typesString: String = String(detail.types.map({ $0.type.name.capitalized }).joined(separator: ", "))
            cell.typeLabel.text = typesString
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon: Pokemon = pokemons[indexPath.row]
        guard let pokemonImage = pokeAPI.imagesCache.object(forKey: pokemon) else { return }
        performSegue(withIdentifier: "showPokemon", sender: (pokemon, pokemonImage))
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.bounds.height > scrollView.contentSize.height {
            pokeAPI.requestPokemonList { pokemons in
                self.pokemons += pokemons
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemon" {
            guard let pokemonDetailsTableViewController = segue.destination as? PokemonViewController else { return }
            guard let (pokemon, pokemonImage) = sender as? (Pokemon, UIImage) else { return }
            pokemonDetailsTableViewController.pokemon = pokemon
            pokemonDetailsTableViewController.pokemonImage = pokemonImage
        }
    }
}
