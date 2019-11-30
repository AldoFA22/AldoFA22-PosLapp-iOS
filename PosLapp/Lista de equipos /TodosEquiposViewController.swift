//
//  TodosDetallesViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/18/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import Kingfisher

class TodosDetallesViewController: UITableViewController {
    var arrData = [ListaEquipos]()
}

extension TodosDetallesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
    }
    
    func getdata(){
        let url = URL(string: "http://10.50.93.30:10010/equipos")
        //let url = URL(string: "http://192.168.1.73:10010/equipos")
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            do{if error == nil{
                self.arrData = try
                    JSONDecoder().decode([ListaEquipos].self, from: data!)
                
                for mainarr in self.arrData{
                    print(mainarr.nombreEquipo, ":", mainarr.modeloEquipo)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                }
            }catch{
                print(data!)
                print(response!)
                print(error)
                print("Error in get json data")
            }
        }.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let launchViewController = segue.destination as? DetalleViewController {
            launchViewController.unEquipo = arrData[indexPath.row]
        }
    }
}

extension TodosDetallesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LaunchEquipos
        
        let launch = arrData[indexPath.row]
        cell.nombreEquipo.text = launch.nombreEquipo
        cell.modeloEquipo.text = launch.modeloEquipo
        cell.serieEquipo.text = launch.serieEquipo
        cell.imagenEquipo.kf.setImage(with: URL(string: arrData[indexPath.row].imagenEquipo))
        return cell
    }
}

class LaunchEquipos: UITableViewCell {
    @IBOutlet var imagenEquipo: UIImageView!
    @IBOutlet var nombreEquipo: UILabel!
    @IBOutlet var serieEquipo: UILabel!
    @IBOutlet var modeloEquipo: UILabel!
}
