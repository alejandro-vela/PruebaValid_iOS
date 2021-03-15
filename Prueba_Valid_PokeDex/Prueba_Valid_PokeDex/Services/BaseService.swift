//
//  BaseService.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//

import Foundation
import Moya
import Combine
import CombineMoya

enum BaseService {
    static let provider = MoyaProvider<ServicePk>()
    
    static func getPokemonFullList(offset: Int, limit: Int) -> AnyPublisher<PokemonFullList, MoyaError> {
        return getPokemonList(offset: offset, limit: limit)
            .flatMap { instanceResponseList in
                Publishers.Sequence(sequence: instanceResponseList.results)
                    .flatMap { instance in
                        BaseService.getPokemon(id: Int(instance.url.split(separator: "/").last!) ?? 0)
                            .eraseToAnyPublisher()
                    }
                    .collect()
                    .map { pokemons -> PokemonFullList in
                        return PokemonFullList(results: pokemons.sorted { $0.id < $1.id }, next: instanceResponseList.next != nil)
                    }
            }
            .eraseToAnyPublisher()
    }
    static func getPokemonList(offset: Int, limit: Int) -> AnyPublisher<PokemonList, MoyaError> {
        return provider.requestPublisher(.getListPk(offset: offset, limit: limit))
            .map(PokemonList.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func getPokemon(id: Int) -> AnyPublisher<Pokemon, MoyaError> {
        return provider.requestPublisher(.getOnePk(id: id))
            .map(Pokemon.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
