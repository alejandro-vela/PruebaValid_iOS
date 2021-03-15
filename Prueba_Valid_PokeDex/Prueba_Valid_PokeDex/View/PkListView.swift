//
//  PkListView.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonListView: View {
    let pokemons: [PokemonListEmpty]
    let onScrollBottom: ()-> Void
    
    var body: some View{
        List{
            pokemonList
//
        }
    }
    
    private var pokemonList: some View{
        ForEach(pokemons){
            pokemon in
            ZStack{
                NavigationLink(destination:DetailPk(viewModel:PokeVM(id: pokemon.number))){
                    EmptyView()
                }
                .hidden()
                .buttonStyle(PlainButtonStyle())
                PokemonGrid(current: pokemon)
            }
            .onAppear{
                if self.pokemons.last == pokemon{
                    self.onScrollBottom()
                }
            }
        }
    }
}


struct PokemonGrid: View {
    let current: PokemonListEmpty
    
    var body: some View{
        HStack{
            WebImage(url: URL(string: current.img)).resizable().scaledToFit().frame(width: 50, height: 50,alignment: .center)
            VStack(alignment: .leading){
                Text(current.name).font(.system(size: 19))
                Text(current.number == 0 ? "-" : "# \(current.number)").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: -20){
                ForEach(current.types, id: \.self){
                    type in
                    Image("Types-\(type.capitalized)")
                }
            }
        }
        .padding(.trailing, -20)
    }
}
