//
//  ListaEquiposViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/20/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
//Hacer struct de tipo equipos

struct POSTApartados: Codable {
    let AlumnosSolicitante: Int
    let gradoObtenerBitAp: String
    let documentoAGenerarBitAp: String
    let actividadRealizarBitAp: String
    let descripcionBitAp: String
    let AlumnosIdUsuario: Int
    let AlumnosIdProfesorResponsable: Int
    let fechaInitBitAp: String
    let fechaFinBitAp: String
    let ZonasIdZonas: Int
}

struct equiposJSON: Codable {
    let nombreEquipo: String
    let id: Int
}

class ListaBitApViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var usuarioGet = String()
    var usuarioGetId = Int()
    var profesorGet = String()
    var profesorGetId = Int()
    var gradoGet = String()
    var documentoGet = String()
    var proyectoGet = String()
    var descripcionGet = String()
    var fechaInicioGet = String()
    var fechaFinalGet = String()
    var zonaGet = String()
    var zonaGetId = Int()
    var BitApartadoId: Int = 0
    
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var responsableLabel: UILabel!
    @IBOutlet weak var documentoGenerarLabel: UILabel!
    @IBOutlet weak var gradoLabel: UILabel!
    @IBOutlet weak var proyectoLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var fechaInicioLabel: UILabel!
    @IBOutlet weak var fechaFinalLabel: UILabel!
    @IBOutlet weak var zonaLabel: UILabel!
    
    @IBOutlet var listTableView: UITableView!
    
    var arrdata = [equiposJSON]()
    var listaEquipos = [equiposJSON]()
    var listaEquiposS = [Int]()
    var nuevaListaEquiposS = [Int]()
    var arrData = [String]()
    var selectArr = [String]()
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok Button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getdata()
        //listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, HH:mm"
        let date = dateFormatter.date(from: fechaInicioGet)

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let goodDate = dateFormatter.string(from: date!)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MMM/yyyy, HH:mm"
        let date2 = dateFormatter2.date(from: fechaFinalGet)

        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let goodDate2 = dateFormatter2.string(from: date2!)
        
        usuarioLabel.text = usuarioGet
        responsableLabel.text = profesorGet
        gradoLabel.text = gradoGet
        documentoGenerarLabel.text = documentoGet
        proyectoLabel.text = proyectoGet
        descripcionLabel.text = descripcionGet
        fechaInicioLabel.text = goodDate
        fechaFinalLabel.text = goodDate2
        zonaLabel.text = zonaGet
        
        listTableView.isEditing = true
        listTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func getdata(){
        //arrData = ["hola1","hola2","hola3","hola4","hola5"]
        zonaLabel.text = zonaGet
        if zonaLabel.text == "No restringida" {
            let url1 = URL(string: "http://10.50.93.30:10010/equiposByZona/1")
//        let url1 = URL(string: "http://192.168.1.73:10010/equiposByZona/1")
            URLSession.shared.dataTask(with: url1!){ (data, response, error) in
                do{if error == nil{
                    self.arrdata = try
                        JSONDecoder().decode([equiposJSON].self, from: data!)

                    for mainarr in self.arrdata{
                        print( ":", mainarr.nombreEquipo)
                        DispatchQueue.main.async {
                            self.listTableView.reloadData()
                        }
                    }
                }
            }catch{
                print("Error in get json data")
                }
            }.resume()
        }
            
        else if zonaLabel.text == "Parcialmente restringida" {
//        let url2 = URL(string: "http://10.50.93.30:10010/equiposByZona/2")
        let url2 = URL(string: "http://10.50.93.30:10010/equiposByZona/2")
            URLSession.shared.dataTask(with: url2!){ (data, response, error) in
                do{if error == nil{
                    self.arrdata = try
                        JSONDecoder().decode([equiposJSON].self, from: data!)

                    for mainarr in self.arrdata{
                        print( ":", mainarr.nombreEquipo)
                        DispatchQueue.main.async {
                            self.listTableView.reloadData()
                        }
                    }
                }
                }catch{
                print("Error in get json data")
                }
            }.resume()
        }
        else if zonaLabel.text == "Restringida" {
            let url3 = URL(string: "http://10.50.93.30:10010/equiposByZona/3")
//            let url3 = URL(string: "http://192.168.1.73:10010/equiposByZona/3")
            URLSession.shared.dataTask(with: url3!){ (data, response, error) in
                do{if error == nil{
                    self.arrdata = try
                        JSONDecoder().decode([equiposJSON].self, from: data!)

                    for mainarr in self.arrdata{
                        print( ":", mainarr.nombreEquipo)
                        DispatchQueue.main.async {
                            self.listTableView.reloadData()
                        }
                    }
                }
            }catch{
                print("Error in get json data")
                }
            }.resume()
        }
    }
    
    @IBAction func Lista(_ sender: Any) {
        print(listaEquipos)
        
        let myUrl = URL(string: "http://10.50.93.30:10010/bitacoraApartados")
        //let myUrl = URL(string: "http://192.168.1.73:10010/bitacoraApartados")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
     
        print(usuarioGetId)
        print(gradoLabel.text!)
        print(documentoGenerarLabel.text!)
        print(proyectoLabel.text!)
        print(descripcionLabel.text!)
        print(usuarioGetId)
        print(profesorGetId)
        print(fechaInicioLabel.text!)
        print(fechaFinalLabel.text!)
        print(zonaGetId)
                
        let postString = ["AlumnosSolicitante":usuarioGetId,
                              "gradoObtenerBitAp":gradoLabel.text!,
                              "documentoAGenerarBitAp":documentoGenerarLabel.text!,
                              "actividadRealizarBitAp":proyectoLabel.text!,
                              "descripcionBitAp":descripcionLabel.text!,
                              "AlumnosIdUsuario":usuarioGetId,
                              "AlumnosIdProfesorResponsable":profesorGetId,
                              "fechaInitBitAp":fechaInicioLabel.text!,
                              "fechaFinBitAp":fechaFinalLabel.text!,
                              "ZonasIdZonas":zonaGetId] as [String : Any]


        do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)//Convertimos el diccionario a formato Json
            } catch let error {
                print(error.localizedDescription)
                displayMessage(userMessage: "Something wrong ocurred. Please try again1")
                return
            }

            //Mandar http request
            let task = URLSession.shared.dataTask(with: request) {(data:Data?, response:URLResponse?, error:Error?) in

            //    self.removeActivityIndicator(activityIndicator: myActivityIndicator)

                if error != nil {
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later2")
                    print("error=\(String(describing:error))")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                    if let parseJSON = json {
                        let ApartadoId = parseJSON["id"] as? Int
                        self.BitApartadoId = ApartadoId!
                        print("Bit Apartado id: =\(String(describing:ApartadoId!))")
                        
                        if ApartadoId != nil {
                            
                                print(parseJSON)
                            DispatchQueue.main.async {
                                self.POSTApartadoHasEquipo(ApartadoId: ApartadoId!)
                            }
                            
                            self.displayMessage(userMessage: "User registered successfully. Please proceed to sign in4")
                        }
                        else {
                            self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later3")
                        }
                    }
                    else{
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later4")
                    }

                } catch {
                   // self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later6")
                    print(response!)
                    print(error)
                }
            }
            task.resume()
    }
        
    
    
    /*
    // MARK: - Table Views

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = arrdata[indexPath.row].title
        
        let cell: DatosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DatosTableViewCell
        cell.listaEquipo.text =  arrdata[indexPath.row].nombreEquipo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select")
        self.estructurarLista(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Deselect")
        self.estructurarLista(tableView: tableView, indexPath: indexPath)
    }
    
}

extension ListaBitApViewController{
    
    func estructurarLista(tableView: UITableView, indexPath: IndexPath){
        self.listaEquiposS.removeAll()
        if let arr = tableView.indexPathsForSelectedRows{
            //print (arr)
            for index in arr {
                listaEquiposS.append(arrdata[index.row].id)
            }
        }
        print()
        print(listaEquiposS)
        nuevaListaEquiposS = [listaEquiposS.count]
        print(nuevaListaEquiposS)
    }
    
    
    func POSTApartadoHasEquipo(ApartadoId: Int){
        print("Aqui empieza post Apartado Has equipo")
        print(ApartadoId)
        print(listaEquiposS)
        
        let stringArray = listaEquiposS.map { String($0) }
        let stringApartados = stringArray.joined(separator: "/")
        
        print(stringApartados)

        //Crear indicador de actividad
        let myActivityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        
        //Posicion del indicador en el storyboard
        myActivityIndicator.center = view.center

        //Evitar que este escondido
        myActivityIndicator.hidesWhenStopped = false

        //Comenzar indicador
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)

        // let myUrl = URL(string: "http://192.168.1.91:10010/alumnos")
        let myUrl = URL(string: "http://10.50.93.30:10010/bitacoraApartados_has_Equipo")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ["BitApIdBAhE":ApartadoId,"EquiposIdBAhE":stringApartados] as [String:Any]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)//Convertimos el diccionario a formato Json
        } catch let error {
            print("error" + error.localizedDescription)
            displayMessage(userMessage: "Something wrong ocurred. Please try again1")
            return
        }
        let task = URLSession.shared.dataTask(with: request) {(data:Data?, response:URLResponse?, error:Error?) in

            self.removeActivityIndicator(activityIndicator: myActivityIndicator)

            if error != nil {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later2")
                print("error=\(String(describing:error))")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                if let parseJSON = json {
                    let ApartadoEquipoId = parseJSON["id"] as? Int
                    print("Bitacora has equipo id: =\(String(describing:ApartadoEquipoId!))")

                    if ApartadoEquipoId != nil {
                        print(parseJSON)
                        self.displayMessage(userMessage: "El registro de apartado se realizo con exito")
                    }
                    else {
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later3")
                    }
                }
                else{
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later4")
                }
            }
            catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later6")
            }
            print(error)
            print(data)
            print(response)
        }
        task.resume()
    }
}

extension DateFormatter {
    static let fullISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
