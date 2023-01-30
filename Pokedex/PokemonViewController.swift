//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Isaac Gongora on 25/01/23.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var pokemonImage: UIImage?
    var pokemon: Pokemon?
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = pokemon?.name.capitalized
        imageView.image = pokemonImage
        
        tableView.sectionHeaderTopPadding = .zero
        
        guard let pokemonDetails = pokemon?.detail else { return }

        // Types
        let typesOptions: [Option] = pokemonDetails.types.map { Option(title: $0.type.name.capitalized, value: "") }
        let typesSection: Section = Section(title: "Types", options: typesOptions)
        
        // Descriptions
        let descriptionOptions: [Option] = [
            Option(title: "Base experience", value: "\(pokemonDetails.base_experience)"),
            Option(title: "Weight", value: "\(pokemonDetails.weight)"),
            Option(title: "Height", value: "\(pokemonDetails.height)")
        ]
        let descriptionSection: Section = Section(title: "Description", options: descriptionOptions)
        
        // Stats
        let statsOptions: [Option] = pokemonDetails.stats.map { Option(title: $0.stat.name.capitalized, value: "\($0.base_stat)") }
        let statsSection: Section = Section(title: "Stats", options: statsOptions)
        
        // Abilities
        let abilitiesOptions: [Option] = pokemonDetails.abilities.map { Option(title: $0.ability.name.capitalized, value: "") }
        let abilitiesSection: Section = Section(title: "Abilities", options: abilitiesOptions)
        
        // Moves
        let movesOptions: [Option] = pokemonDetails.moves.map { Option(title: $0.move.name.capitalized.replacingOccurrences(of: "-", with: " "), value: "") }
        let movesSection: Section = Section(title: "Moves", options: movesOptions)
        
        sections = [typesSection, descriptionSection, statsSection, abilitiesSection, movesSection]
    }

    // MARK: - Supporting files
    typealias Option = (title: String, value: String)
    typealias Section = (title: String, options: [Option])
}

extension PokemonViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonDetailCell", for: indexPath) as! PokemonDetailCell
        
        let option: Option = sections[indexPath.section].options[indexPath.row]
        cell.detailLabel.text = option.title
        cell.valueLabel.text = option.value
        
        return cell
    }
}

extension PokemonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = UILabel()
        label.backgroundColor = .systemRed
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "  " + sections[section].title

        return label
    }
}
