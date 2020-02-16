//
//  ViewController.swift
//  Prueba
//
//  Created by Usuario on 12/02/20.
//  Copyright © 2020 Janes saenz puerta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    var navVC: UINavigationController!
    @IBOutlet weak var navegator: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 2.0, bottom: 5.0, right: 2.0)
    var heroes = [variables]()
    var imagenok = [imagen]()
    var arrayVacio = [String]()
    private let itemsPerRow: CGFloat = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive =  true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        proyectos()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "search"
        
        navigationItem.searchController = search
        

    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let cellsize = CGSize(width: collectionView.bounds.size.width/2, height:collectionView.bounds.size.height/3)
        return cellsize
    }

    // En viewDidLoad.
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TableController
        let hero: variables
        hero = heroes[indexPath.row]
        //let urlok = "https://softsaenz.com/wp-content/uploads/2018/03/softsaenz2blanco.png"
        cell.itemLabel.text = hero.name
        if self.imagenok.isEmpty {
            for _ in 0..<indexPath.count {
                    Alamofire.request(hero.team!).responseJSON { response in
                        
                        //getting json
                        if response.result.isSuccess {
                           let array_json: JSON = JSON(response.result.value!)
                                let objetos = array_json["sprites"]["back_default"]
                                debugPrint(objetos as Any)
                            self.arrayVacio.append(
                                "\(objetos)"
                            )
                            self.imagenok.append(imagen(
                                img: objetos as? String
                            ))
                            let url = URL(string:"\(objetos)" as String)
                            //print(url!)
                            if let data = try? Data(contentsOf: url!)
                            {
                                let image_final: UIImage = UIImage(data: data)!
                                cell.itemImage.image = image_final
                            }
                            
                        }else{
                            print("error: \(String(describing: response.result.error))")
                        }
                        //displaying data in tableview
                    }
                }
                SwiftSpinner.hide()
            //debugPrint(self.arrayVacio[0] as Any)
        }
        
        
        //cell.itemImage.load(url: url!)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
        let hero1: variables
        hero1 = heroes[indexPath.row]
           
        let descripion  = hero1.team
               //print(hero1 as Any)
               // Get Cell Label
               //let indexPath = tableView.indexPathForSelectedRow
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let viewController = storyboard.instantiateViewController(withIdentifier: "detalle") as! DetallesController
               viewController.receivedString = descripion!

              
               
               //viewController.nombre1 = nombre1!
               self.present(viewController, animated: true , completion: nil)
    }
    func proyectos(){
        //print(data)
        SwiftSpinner.show("Contectando con el servidor...")
        Alamofire.request(Router.readUsers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let array_json: JSON = JSON(response.result.value!)
                let objetos = array_json["results"]
                
                let guardar = objetos.arrayObject
                //debugPrint(guardar as Any)
                let heroesArray : NSArray  = guardar! as NSArray
                //print(guardar as Any)
                for i in 0..<heroesArray.count {
                   self.heroes.append(variables(
                        name: (heroesArray[i] as AnyObject).value(forKey: "name") as? String,
                        team: (heroesArray[i] as AnyObject).value(forKey: "url") as? String
                    ))
                }
                //debugPrint(self.imagenok as Any)
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
                SwiftSpinner.hide()
                //Defaults.clearUserData()
            }
        }
        self.collectionView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
        self.collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
