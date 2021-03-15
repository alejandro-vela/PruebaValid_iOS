//
//  DetailPk.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 14/03/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailPk: View{
    @ObservedObject var viewModel: PokeVM
    
    var body: some View{
        VStack{
            if viewModel.state.pokemon != nil{
                detail
            }
        }.onAppear{
            viewModel.getData()
        }
    }
    
    private var detail: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .clear]), startPoint: .leading, endPoint: .trailing).padding(.bottom, 80)
            VStack(spacing: 0){
                WebImage(url: URL(string: viewModel.state.pokemon!.image)).resizable().placeholder(Image("Pokeball")).scaledToFit().frame(width: 200, height: 200, alignment: .center)
                VStack{
                    Text("\(viewModel.state.pokemon!.name.capitalized)").foregroundColor(Color("TextColor"))
                    HStack(){
                        ForEach(viewModel.state.pokemon!.types, id: \.self){
                            item in
                            Image("Tag-\(item.capitalized)")
                        }
                    }.padding(.bottom, 18)
                    Text("\(viewModel.state.pokemon!.flavorText)").font(.title).fontWeight(.bold).foregroundColor(Color("TextColor"))
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(50)
            }.padding(.top, 100)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct DetailPk_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailPk(viewModel: PokeVM(id: 1)).edgesIgnoringSafeArea(.horizontal)
        }
    }
}
