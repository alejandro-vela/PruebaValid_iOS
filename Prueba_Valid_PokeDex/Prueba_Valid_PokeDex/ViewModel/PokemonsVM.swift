//
//  PokemonsVM.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//

import Foundation
import Moya
import RealmSwift
import Combine

struct PokemonListEmpty: Identifiable, Equatable {
    var id = UUID()
    var name: String = ""
    var number : Int = 0
    var img : String = ""
    var types: [String] = []
    
}

class PokemonsVM: ObservableObject {
    @Published private(set) var state = State()
    
    private var subcriptions = Set<AnyCancellable>()
    
    //only if possible
    func nextPage(){
        guard state.canLoadNextPage else {return}
        
        let limited = state.offset + ServicePk.pageSize
        
        BaseService.getPokemonFullList(offset: state.offset, limit: limited)
            .sink(receiveCompletion: onReceive, receiveValue: onReceiveValue)
            .store(in: &subcriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<MoyaError>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }
    
    private func onReceiveValue(_ data: PokemonFullList){
        let realmIntance = try! Realm()
        try! realmIntance.write{
            realmIntance.add(data.results, update: .all)
        }
        
        state.pokemons += data.results.map{ pokemon in
            PokemonListEmpty(
                name: pokemon.name!,
                number: pokemon.id,
                img: pokemon.sprites!.other!.officialArtwork!.frontDefault!,
                types: pokemon.types.map{$0.type!.name!}
            )
        }
        state.offset += ServicePk.pageSize
        state.canLoadNextPage = data.next
    }
    
    
    struct State {
        var pokemons: [PokemonListEmpty] = []
        var offset: Int = 0
        var canLoadNextPage = true
    }
    
}
