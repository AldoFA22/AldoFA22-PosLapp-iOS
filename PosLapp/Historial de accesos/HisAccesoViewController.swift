//
//  HisAccesoViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/11/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
//En el jsonstruct mandamos a llamar los parametros de cada objeto, el detalle es que se deben llamar igual para que json los agarre
struct jsonstruct: Decodable {
    let title: String
    let completed: Bool
}

struct BitacoraAcceso: Decodable {
    let id: Int
    let AlumnosIdAlumno: Int
    let fechaInitBitAc: String
    let fechaFinBitAc: String
}

class HisAccesoviewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableview: UITableView!
    var arrdata = [jsonstruct]()
    var arrData = [BitacoraAcceso]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
    }
    
    func getdata(){
        let url = URL(string: "http://192.168.1.73:10010/bitAcAlumnos/1")
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            do{if error == nil{
                self.arrData = try
                    JSONDecoder().decode([BitacoraAcceso].self, from: data!)
                
                for mainarr in self.arrData{
                    print(mainarr.fechaInitBitAc, ":", mainarr.fechaFinBitAc)
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                }
                }
            }catch{
                print(data)
                print(response)
                print(error)
                print("Error in get json data")
            }
        }.resume()
    }
    
    //TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.allowsSelection = false
        let cell:DatosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DatosTableViewCell
        cell.fentrada.text = arrData[indexPath.row].fechaInitBitAc
        cell.fsalida.text = arrData[indexPath.row].fechaFinBitAc
        return cell
    }
    
}
