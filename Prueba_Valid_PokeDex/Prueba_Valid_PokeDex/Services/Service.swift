//
//  Service.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//

import Foundation
import Moya

enum ServicePk {
    case getListPk(offset: Int, limit: Int)
    case getOnePk(id: Int)
    static let pageSize = 20
}

extension ServicePk: TargetType{
    var baseURL: URL{
        return URL(string: "https://pokeapi.co/api/v2")!
    }
    
    var path: String {
        switch self {
        case .getListPk(_, _):
            return "/pokemon"
        case .getOnePk(let id):
            return "/pokemon/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListPk, .getOnePk:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getListPk(_, _):
            guard let url = Bundle.main.url(forResource: "AllPokemos", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getOnePk(_):
            guard let url = Bundle.main.url(forResource: "OnePokemon", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    
    var task: Task {
        switch self {
        case let .getListPk(offset, limit):
            return .requestParameters(parameters: ["offset": offset, "limit": limit], encoding: URLEncoding.queryString)
        case .getOnePk(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
