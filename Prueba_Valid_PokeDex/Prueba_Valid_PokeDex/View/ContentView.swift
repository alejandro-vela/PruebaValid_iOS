//
//  ContentView.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//

import SwiftUI

struct ContentView: View {
    @State private var section = 0
    @State var textValue: String = ""
    @ObservedObject var viewModel = PokemonsVM()
    @State var isActive : Bool = false
    @State var notFound : Bool = false
    @State var searchPk : Int = 0
    @State var flag: Bool = false

    
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    var alert: Alert{
        Alert(title: Text("Not found"))
    }
    var body: some View {
        NavigationView{
            TabView(selection: $section){
                VStack{
                    HStack{
                        TextField("Search",
                                  text: $textValue.onChange(nameChanged))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(lightGreyColor)
                            .cornerRadius(20)
                        Spacer()
                        NavigationLink(
                            destination: DetailPk(viewModel:PokeVM(id: searchPk)),
                            isActive: self.$isActive,
                            label: {
                                Text("")
                            })
                            
                            .hidden()
                            .buttonStyle(PlainButtonStyle())
                        Image("Search").resizable()
                            .frame(width: 30,
                                   height: 30,
                                   alignment:.center)
                            .onTapGesture {
                                if(!textValue.isEmpty){
                                    if self.flag {
                                        self.textValue = ""
                                        flag = false
                                        self.isActive = true
                                    }else{
                                        self.textValue = ""
                                        self.notFound.toggle()
                                    }
                                    
                                }else{
                                    self.textValue = ""
                                    self.notFound.toggle()
                                }
                            }
                        
                    }.padding()
                    pkListView
                }
                .tabItem{
                    Text("Pokemon")
                }
                .tag(0)
                Text("Moves")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Text("Moves")
                    }
                    .tag(1)
                
                Text("Items")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Text("Items")
                    }
                    .tag(2)
            }
            .accentColor(.black)
            .onAppear(){
                UITabBar.appearance().barTintColor = .white
            }.navigationTitle("Pokemon")
        }
        .accentColor(.white)
        .alert(isPresented: self.$notFound, content: {
            self.alert
        })
    }
    func nameChanged(to value: String)  {
        let data = viewModel.state.pokemons
        data.forEach{item in
            if(item.name.capitalized == textValue.capitalized){
                flag = true
                searchPk = item.number
                
            }
        }
        print("Si entre\(self.flag)")
    }
    private var pkListViewSearch: some View {
        
        return PokemonListView(
            pokemons: viewModel.state.pokemons,
            onScrollBottom: viewModel.nextPage
        )
        .onAppear(perform: viewModel.nextPage)
    }
    
    private var pkListView: some View {
        PokemonListView(
            pokemons: viewModel.state.pokemons,
            onScrollBottom: viewModel.nextPage
        )
        .onAppear(perform: viewModel.nextPage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
