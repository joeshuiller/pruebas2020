//
//  DetallesController.swift
//  Prueba
//
//  Created by Usuario on 16/02/20.
//  Copyright © 2020 Janes saenz puerta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class DetallesController: UIViewController{
    var receivedString = ""
    
    @IBOutlet weak var tipol: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var pokemon: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedString)
        self.tipol.layer.cornerRadius = 8.0
        if !receivedString.isEmpty {
           datos(url: receivedString)
        }
        SwiftSpinner.show("Contectando con el servidor...")
    }
    func datos(url: String) {
        Alamofire.request(url).responseJSON { response in
            
            //getting json
            if response.result.isSuccess {
               let array_json: JSON = JSON(response.result.value!)
                    let objetos = array_json["sprites"]["back_default"]
                    let nombre = array_json["name"]
                    let tipo = array_json["types"][0]["type"]["name"]
                    debugPrint(tipo as Any)
                let url = URL(string:"\(objetos)" as String)
                //print(url!)
                if let data = try? Data(contentsOf: url!)
                {
                    let image_final: UIImage = UIImage(data: data)!
                    self.pokemon.image = image_final
                }
                self.tipol.text = "\(tipo)"
                self.descripcion.text = "\(nombre)"
                self.titulo.text = "\(nombre)"
                
                 SwiftSpinner.hide()
            }else{
                print("error: \(String(describing: response.result.error))")
            }
            //displaying data in tableview
        }
    }
}
