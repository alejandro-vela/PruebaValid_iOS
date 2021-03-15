//
//  Pokemon.swift
//  Prueba_Valid_PokeDex
//
//  Created by Alejo Muñoz on 13/03/21.
//


import Foundation
import Realm
import RealmSwift

// MARK: - Pokemon
@objcMembers class Pokemon: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String? = nil
    @objc dynamic var sprites: Sprites?
    let types = RealmSwift.List<TypeElement>()
    let abilities = RealmSwift.List<Ability>()
    @objc dynamic var baseExperience: Int = 0
    let forms = RealmSwift.List<Species>()
    let gameIndices = RealmSwift.List<GameIndex>()
    @objc dynamic var height: Int = 0
    @objc dynamic var isDefault: Bool = false
    @objc dynamic var locationAreaEncounters: String? = nil
    let moves = RealmSwift.List<Move>()
    @objc dynamic var order: Int = 0
    @objc dynamic var species: Species?
    let stats = RealmSwift.List<Stat>()
    @objc dynamic var weight: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case sprites = "sprites"
        case types = "types"
        case abilities = "abilities"
        case baseExperience = "base_experience"
        case forms = "forms"
        case gameIndices = "game_indices"
        case height = "height"
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves = "moves"
        case order = "order"
        case species = "species"
        case stats = "stats"
        case weight = "weight"
    }
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        sprites = try container.decode(Sprites.self, forKey: .sprites)
        
        let typesList = try container.decode([TypeElement].self, forKey: .types)
        types.append(objectsIn: typesList)
    }
    
}

// MARK: - Ability
@objcMembers class Ability: Object, Decodable {
    @objc dynamic var ability: Species?
    @objc dynamic var isHidden: Bool = false
    @objc dynamic var slot: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case ability = "ability"
        case isHidden = "is_hidden"
        case slot = "slot"
    }
}

// MARK: - Named
@objcMembers class Named: Object, Decodable {
    @objc dynamic var name: String? = nil
    @objc dynamic var url: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
    }
}

// MARK: - GameIndex
@objcMembers class GameIndex: Object, Decodable {
    @objc dynamic var gameIndex: Int = 0
    @objc dynamic var version: Named?
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version = "version"
    }
}

// MARK: - Move
@objcMembers class Move: Object, Decodable {
    @objc dynamic var move: Named?
    var versionGroupDetails = RealmSwift.List<VersionGroupDetail>()
    
    enum CodingKeys: String, CodingKey {
        case move = "move"
        case versionGroupDetails = "version_group_details"
    }
}

// MARK: - VersionGroupDetail
@objcMembers class VersionGroupDetail: Object, Decodable {
    @objc dynamic var levelLearnedAt: Int = 0
    @objc dynamic var moveLearnMethod: Named?
    @objc dynamic var versionGroup: Named?
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

// MARK: - GenerationV
@objcMembers class GenerationV: Object, Decodable {
    @objc dynamic var blackWhite: Sprites?
    
    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}

// MARK: - GenerationIv
@objcMembers class GenerationIv: Object, Decodable {
    @objc dynamic var diamondPearl: Sprites?
    @objc dynamic var heartgoldSoulsilver: Sprites?
    @objc dynamic var platinum: Sprites?
    
    enum CodingKeys: String, CodingKey {
        case diamondPearl = "diamond-pearl"
        case heartgoldSoulsilver = "heartgold-soulsilver"
        case platinum = "platinum"
    }
}

// MARK: - Species
@objcMembers class Species: Object, Decodable {
    @objc dynamic var name: String
    @objc dynamic var url: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}
// MARK: - Sprites
@objcMembers class Sprites: Object, Decodable {
    @objc dynamic var backDefault: String? = nil
    @objc dynamic var backFemale: String? = nil
    @objc dynamic var backShiny: String? = nil
    @objc dynamic var backShinyFemale: String? = nil
    @objc dynamic var frontDefault: String? = nil
    @objc dynamic var frontFemale: String? = nil
    @objc dynamic var frontShiny: String? = nil
    @objc dynamic var frontShinyFemale: String? = nil
    @objc dynamic var other: Other?
    @objc dynamic var animated: Sprites?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other = "other"
        case animated = "animated"
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        frontDefault = try container.decode(String.self, forKey: .frontDefault)
        frontShiny = try container.decode(String.self, forKey: .frontShiny)
        other = try container.decode(Other.self, forKey: .other)
    }
}

 
// MARK: - Stat
@objcMembers class Stat: Object, Decodable {
    @objc dynamic var baseStat: Int = 0
    @objc dynamic var effort: Int = 0
    @objc dynamic var stat: Named?
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort = "effort"
        case stat = "stat"
    }
}

// MARK: - Other
@objcMembers class Other: Object, Decodable {
   // @objc dynamic var dreamWorld: DreamWorld?
    @objc dynamic var officialArtwork: OfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
       // case dreamWorld = "dream_world"
        case officialArtwork = "official-artwork"
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        officialArtwork = try container.decode(OfficialArtwork.self, forKey: .officialArtwork)
    }
}

// MARK: - OfficialArtwork
@objcMembers class OfficialArtwork: Object, Decodable {
    @objc dynamic var frontDefault: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        frontDefault = try container.decode(String.self, forKey: .frontDefault)
    }
}

// MARK: - TypeElement
@objcMembers class TypeElement: Object, Decodable {
    @objc dynamic var slot: Int = 0
    @objc dynamic var type: Named?
    
    enum CodingKeys: String, CodingKey {
        case slot = "slot"
        case type = "type"
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        slot = try container.decode(Int.self, forKey: .slot)
        type = try container.decode(Named.self, forKey: .type)
    }
}
