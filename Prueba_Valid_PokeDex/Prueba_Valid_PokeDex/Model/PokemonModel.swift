//
//  PokemonModel.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//

import Foundation

struct PokemonList: Decodable {
    let count: Int
    let next, previous: String?
    let results: [PokemonName]
}

struct PokemonName: Decodable {
    let name: String
    let url: String
}

struct PokemonFullList {
    let results: [Pokemon]
    let next: Bool
}
