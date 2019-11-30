//
//  HisApartadoViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/12/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
//En el jsonstruct mandamos a llamar los parametros de cada objeto, el detalle es que se deben llamar igual para que json los agarre
struct EquipoObjeto: Decodable {
    let id: Int
    let EquiposNombreEquipo: String
    let fechaInitBitUE: String
    let AlumnosIdAlumno: Int
    let muestraBitUE: String
    let condicionBitUE: String
    let fechaTermBitUE: String
    let Equipo: ListaEquipos
    let Alumno: AlumnoObjeto?
}

struct ListaEquiposObjeto: Decodable{
    let id: Int
    let nombreEquipo: String
    let modeloEquipo: String
    let serieEquipo: String
    let imagenEquipo: String
    let observacionesEquipo: String
    let alimElecEquipo: Int
    let ZonasIdZonas: Int
    let Zona: Zonas
}

struct ZonaObjeto: Decodable {
    let id: Int
    let nombreZona: String
}

struct AlumnoObjeto: Decodable{
    let id: Int
    let usuariosIdUsuarios: Int
    let RolesIdRol: Int
    let InstProcIdInstProc: Int
    let gradoEscolarAlumnos: String?
    let activoAlumnos: Bool
    let fechaInitAlumnos: String
    let fechaFinAlumnos: String
}

class HisApartadoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableview: UITableView!
    var arrdata = [EquipoObjeto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
    }

    func getdata(){
        let alumnoId: String! = KeychainWrapper.standard.string(forKey: "AlumnoId")
        
        let url = URL(string: "http://10.50.93.30:10010/bitUsoEquiposAlumnos/\(alumnoId!)")
        //let url = URL(string: "http://192.168.1.73:10010/bitUsoEquiposAlumnos/1")
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            do{if error == nil{
                self.arrdata = try
                    JSONDecoder().decode([EquipoObjeto].self, from: data!)

                for mainarr in self.arrdata{
                    print(mainarr.muestraBitUE, ":", mainarr.Equipo.id)
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
        return self.arrdata.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DatosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DatosTableViewCell
        if arrdata[indexPath.row].Equipo.ZonasIdZonas == 1 {
            cell.tipoZona.text = "Zona No Restringida"
        }
        else if arrdata[indexPath.row].Equipo.ZonasIdZonas == 2 {
            cell.tipoZona.text = "Zona Parcialmente Restringida"
        }
        else if arrdata[indexPath.row].Equipo.ZonasIdZonas == 3 {
            cell.tipoZona.text = "Zona Restringida"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: arrdata[indexPath.row].fechaInitBitUE)
        dateFormatter.dateFormat = "dd 'de' MMMM, yyyy, HH:mm"
        let goodDate = dateFormatter.string(from: date!)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "es_ES")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date2 = dateFormatter2.date(from: arrdata[indexPath.row].fechaTermBitUE)
        dateFormatter2.dateFormat = "dd 'de' MMMM, yyyy, HH:mm"
        let goodDate2 = dateFormatter2.string(from: date2!)
        
        cell.apEntrada.text = goodDate
        cell.apSalida.text =  goodDate2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detalle:DetallesViewController =  self.storyboard?.instantiateViewController(withIdentifier: "detalles") as! DetallesViewController
        
        if arrdata[indexPath.row].Equipo.ZonasIdZonas == 1 {
            detalle.strzona = "Zona No Restringida"
        }
        else if arrdata[indexPath.row].Equipo.ZonasIdZonas == 2 {
            detalle.strzona = "Zona Parcialmente Restringida"
        }
        else if arrdata[indexPath.row].Equipo.ZonasIdZonas == 3 {
            detalle.strzona = "Zona Restringida"
        }
        detalle.strequipo = "\(arrdata[indexPath.row].Equipo.nombreEquipo)"
        detalle.strmuestra = "\(arrdata[indexPath.row].muestraBitUE)"
        detalle.strcondicion = "\(arrdata[indexPath.row].condicionBitUE)"
        detalle.strfechaInit = "\(arrdata[indexPath.row].fechaInitBitUE)"
        detalle.strfechaFin = "\(arrdata[indexPath.row].fechaTermBitUE)"
        self.navigationController?.pushViewController(detalle, animated: true)
    }
}
