//
//  PokeVM.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//

import Foundation
import Moya
import Combine
import RealmSwift

struct PokemonEntity: Identifiable {
    var id = UUID()
    var name: String = ""
    var number: Int = 0
    var image: String = ""
    var types: [String] = []
    var flavorText: String = ""
}

class PokeVM: ObservableObject {
    let id : Int
    init(id: Int) {
        self.id = id
    }
    @Published private(set) var state = State()
    private var subs = Set<AnyCancellable>()
    
    struct State {
        var pokemon: PokemonEntity?
    }
    
    func getData(){
        let realmInstance = try! Realm()
        
        if let pokemon = realmInstance.objects(Pokemon.self).filter("id ==\(id)").first {
            state.pokemon = PokemonEntity(
                name: pokemon.name!,
                number: pokemon.id,
                image: pokemon.sprites!.other!.officialArtwork!.frontDefault!,
                types: pokemon.types.map{$0.type!.name!}
              //  flavorText: ""
            )
        }else{
            BaseService.getPokemon(id: id).sink(
                receiveCompletion: onReceive,
                receiveValue: onValueReceive)
                .store(in: &subs)
        }
    }
    
    private func onReceive(_ completion: Subscribers.Completion<MoyaError>) {
        switch completion {
        case .finished:
            break
        case .failure:
            break
        }
    }
    
    private func onValueReceive(_ data: Pokemon) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(data, update: .all)
        }
        
        state.pokemon = PokemonEntity(
            name: data.name!.capitalized,
            number: data.id,
            image: data.sprites!.other!.officialArtwork!.frontDefault!,
            types: data.types.map { $0.type!.name! }
        )
    }
    
}
