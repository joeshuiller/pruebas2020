//
//  Router.swift
//  Prueba
//
//  Created by Usuario on 12/02/20.
//  Copyright © 2020 Janes saenz puerta. All rights reserved.
//

import Foundation
import Alamofire
  
enum Router: URLRequestConvertible {
    case readUsers
    case createUser(parameters: Parameters)
    case sesion(parameters: Parameters)
    case cordenadas(parameters: Parameters)
    case puntos(parameters: Parameters)
    case productos(parameters: Parameters)
    case proyectos(parameters: Parameters)
    case inventario(parameters: Parameters)
    case getinventario(parameters: Parameters)
    case ventasdegus(parameters: Parameters)
    case ventasdeclaro(parameters: Parameters)
    case uploadPicture(parameters: Parameters)
    case readUser(username: String)
    case updateUser(username: String, parameters: Parameters)
    case destroyUser(username: String)
    // 1
    enum Constants {
      static let baseURLPath = "https://pokeapi.co/api/v2/"
    }

    // Using a fake URL to get data
    //static let baseURLString = "https://private-85a46-routable.apiary-mock.com"

    var method: HTTPMethod {
        switch self {
        case .readUsers:
            return .get
        case .createUser:
            return .post
        case .sesion, .cordenadas, .puntos, .proyectos, .productos
        , .inventario, .getinventario, .ventasdegus, .ventasdeclaro:
            return .post
        case .uploadPicture(_):
            return .post
        case .readUser:
            return .get
        case .updateUser:
            return .put
        case .destroyUser:
            return .delete
        }
    }
//get_punto_proyect_app
    var path: String {
        switch self {
        case .readUsers:
            return "pokemon"
        case .createUser:
            return "/sesion"
        case .productos:
            return "/get_produtc"
        case .sesion:
            return "/sesion"
        case .proyectos:
            return "/get_punto_proyect_app"
        case .cordenadas:
            return "/registrar_sesion"
        case .puntos:
            return "/ubicacioninfinity"
        case .inventario:
            return "/insert_inventario_pdv"
        case .getinventario:
            return "/get_inventario_pdv"
        case .ventasdegus:
            return "/insert_registro_pdv"
        case .ventasdeclaro:
            return "/registrosclarotec"
        case .readUser(let username):
            return "/users/\(username)"
        case .updateUser(let username, _):
            return "/users/\(username)"
        case .destroyUser(let username):
            return "/users/\(username)"
        case .uploadPicture(_):
            return "api/upload-picture/"
        }
    }

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
       let url = try Constants.baseURLPath.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = TimeInterval(10 * 1000)

        switch self {
        case .createUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .sesion(let parameters), .cordenadas (let parameters), .puntos(let parameters), .proyectos(let parameters), .productos(let parameters), .inventario(let parameters), .getinventario(let parameters), .ventasdegus(let parameters), .ventasdeclaro(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateUser(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .uploadPicture(let parameters):
            urlRequest = try! JSONEncoding.default.encode(urlRequest, with: parameters)
        case .readUsers:
            urlRequest = try! JSONEncoding.default.encode(urlRequest)
        default:
            break
        }

        return urlRequest
    }
}
