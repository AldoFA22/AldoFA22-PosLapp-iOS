//
//  JsonModel.swift
//  PosLapp
//
//  Created by Administrador on 11/14/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import SwiftyJSON
//Modelo Apartado equipos SwiftyJson
struct ListaEquipos{
    let id: Int
    let nombreEquipo: String
    let modeloEquipo: String
    let serieEquipo: String
    let imagenEquipo: String
    var imagenEquipoURL: UIImage?
    let observacionesEquipo: String
    let alimElecEquipo: Int
    let ZonasIdZonas : Int
    let Estatus: Estatuses?
    let Zona: Zonas?
}

extension ListaEquipos: Decodable{
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nombreEquipo = "nombreEquipo"
        case modeloEquipo = "modeloEquipo"
        case serieEquipo = "serieEquipo"
        case imagenEquipo = "imagenEquipo"
        case observacionesEquipo = "observacionesEquipo"
        case alimElecEquipo = "alimElecEquipo"
        case ZonasIdZonas = "ZonasIdZonas"
        case Estatus
        case Zona
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        nombreEquipo = try container.decode(String.self, forKey: .nombreEquipo)
        modeloEquipo = try container.decode(String.self, forKey: .modeloEquipo)
        serieEquipo = try container.decode(String.self, forKey: .serieEquipo)
        imagenEquipo = try container.decode(String.self, forKey: .imagenEquipo)
        observacionesEquipo = try container.decode(String.self, forKey: .observacionesEquipo)
        alimElecEquipo = try container.decode(Int.self, forKey: .alimElecEquipo)
        ZonasIdZonas = try container.decode(Int.self, forKey: .ZonasIdZonas)
        Estatus = try container.decodeIfPresent(Estatuses.self, forKey: .Estatus)
        Zona = try container.decodeIfPresent(Zonas.self, forKey: .Zona)
    }
}

struct Estatuses {
    let id: Int?
    let descripcionEstatus: String?
}

extension Estatuses: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case descripcionEstatus = "descripcionEstatus"
    }
}

struct Zonas {
    let id: Int?
    let nombreZona: String?
}

extension Zonas: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nombreZona = "nombreZona"
    }
}



