//
//  File.swift
//  PosLapp
//
//  Created by Administrador on 11/25/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper


class UsoEquipoViewController: UIViewController,
UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet var equipoTextField: UITextField!
    @IBOutlet var muestraTextField: UITextField!
    @IBOutlet var condicionTextField: UITextField!
    @IBOutlet var fechaInicioTextField: UITextField!
    @IBOutlet var fechaFinalTextField: UITextField!
    
    private var datePickerFecha: UIDatePicker?
    private var datePicker2fecha: UIDatePicker?
    
    private var id: Int = 0
    private var EquipoId: Int = 0
    private var AlumnoId: Int = 1
    
var grado = ["Licenciatura","Maestria","Doctorado"]
var documento = ["Tesis","Reporte","Artículo"]
var proyecto = ["Tesis","Servicio Social","Práctica profesional","Estancia","Práctica de curso"]
var zona = ["No restringida","Parcialmente restringida","Restringida"]
    
    var arrdata = [ListaEquipos]()

override func viewDidLoad() {
    super.viewDidLoad()
    let modelPickerView = UIPickerView()
    modelPickerView.delegate = self
    modelPickerView.tag = 1
    equipoTextField.inputView = modelPickerView
    
    datePickerFecha = UIDatePicker()
    datePickerFecha?.datePickerMode = .time
    let cal = Calendar.current
    let now = Date()  // get the current date and time (2018-03-27 19:38:44)
    let components = cal.dateComponents([.day, .month, .year], from: now)  // extract the date components 28, 3, 2018
    let today = cal.date(from: components)  // build another Date value just with date components, without the time (2018-03-27 00:00:00)
    datePickerFecha?.minimumDate = today?.addingTimeInterval(60 * 60 * 9)  // adds 9h
    datePickerFecha?.maximumDate = today?.addingTimeInterval(60 * 60 * 16) // adds 21h
    datePickerFecha?.minuteInterval = 15
    datePickerFecha?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
    
    
    datePicker2fecha = UIDatePicker()
    datePicker2fecha?.datePickerMode = .time
    let cal2 = Calendar.current
    let now2 = Date()
    let components2 = cal2.dateComponents([.day, .month, .year], from: now2)
    let today2 = cal2.date(from: components2)
    datePicker2fecha?.minimumDate = today2?.addingTimeInterval(60 * 60 * 9)
    datePicker2fecha?.maximumDate = today2?.addingTimeInterval(60 * 60 * 16)
    datePicker2fecha?.minuteInterval = 15
    datePicker2fecha?.addTarget(self, action: #selector(dateChanged2(datePicker:)), for: .valueChanged)
           
    fechaInicioTextField.inputView = datePickerFecha
    fechaFinalTextField.inputView = datePicker2fecha
    
    self.hideKeyboardWhenTappedAround()
    
    let url = URL(string: "http://192.168.137.139:10010/equipos")
    //let url = URL(string: "http://192.168.1.73:10010/equipos")

    URLSession.shared.dataTask(with: url!) { (data, response, err) in
        if err == nil {
            do{
                try self.arrdata = JSONDecoder().decode([ListaEquipos].self, from: data!)
//                print("Respuesta:")
//                print(self.alumnos)
//                print(self.alumnos[0].Usuario.nombreUsuario)
                
    
            }catch{
                print("Parse error")
                print(error)
                
            }
            DispatchQueue.main.async {
             //   self.pickerview.reloadComponent(0)
            }
        }
    }.resume()
}

@objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
    view.endEditing(false)
}
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, HH:mm"
        fechaInicioTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func dateChanged2(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, HH:mm"
        fechaFinalTextField.text = dateFormatter.string(from: datePicker.date)
    }

    
//pickerview methods

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1;
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.tag == 1 {
        return arrdata.count
    }
    else if pickerView.tag == 2 {
      //  return profesor.count
    }
    
    return 0
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.tag == 1 {
        let equipoid = arrdata[row].id
        EquipoId = equipoid
        let equipo = arrdata[row].nombreEquipo
        return equipo
    }
    else if pickerView.tag == 2 {
//        let nombre = profesor[row].Usuario.nombreUsuario
//        let apellido = profesor[row].Usuario.apellido
//        let nombreCompleto = nombre + " " + apellido
//        return nombreCompleto
    }
    return nil
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.tag == 1 {
        if arrdata.count > row {
        let equipoid = arrdata[row].id
        EquipoId = equipoid
        let equipo = arrdata[row].nombreEquipo //PARAMETRO A POSTEAR YA FUNCIONA
        equipoTextField.text = equipo
        view.endEditing(false)
        }
        else {
            print("No hay equipos")
        }
    }
    else if pickerView.tag == 2 {
//        let nombre = profesor[row].Usuario.nombreUsuario
//        let apellido = profesor[row].Usuario.apellido
//        let idProfesor = profesor[row].id //PARAMETRO A POSTEAR YA FUNCIONA
//        ProfesorResponsableId = idProfesor
//        let nombreCompleto = nombre + " " + apellido
//        profesorResponsable.text = nombreCompleto
//        view.endEditing(false)
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
    
    @IBAction func registrar(_ sender: Any) {
        let alumnoId: String! = KeychainWrapper.standard.string(forKey: "AlumnoId")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, HH:mm"
        guard let date = dateFormatter.date(from: fechaInicioTextField.text!) else { return }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let goodDate = dateFormatter.string(from: date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MMM/yyyy, HH:mm"
        guard let date2 = dateFormatter2.date(from: fechaFinalTextField.text!) else {return}

        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let goodDate2 = dateFormatter2.string(from: date2)
        
        print(EquipoId)
        print(goodDate)
        print(muestraTextField.text!)
        print(condicionTextField.text!)
        print(goodDate2)
         
        guard let myUrl = URL(string: "http://192.168.137.139:10010/bitacoraUsoEquipos")
//        guard let myUrl = URL(string: "http://192.168.1.73:10010/bitacoraUsoEquipos")
            else {return}
                var request = URLRequest(url: myUrl)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
                
        let newPost = POSTUsoEquipos(EquiposNombreEquipo: equipoTextField.text!, fechaInitBitUE: goodDate, AlumnosIdAlumno: Int(alumnoId)!, muestraBitUE: muestraTextField.text!, condicionBitUE: condicionTextField.text!, fechaTermBitUE: goodDate2)
                do {
                    let jsonBody = try JSONEncoder().encode(newPost)
                    request.httpBody = jsonBody
                } catch {print("1")
                    print(request)
                    print(error)}
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (data, request, error) in
                    guard let data = data else {return}
                    do {
                        let sentPost = try JSONDecoder().decode(POSTUsoEquipos.self, from: data)
                        print(sentPost)
                    } catch {
                        print("2")
                        print(request)
                        print(error)
                    }
        }
        task.resume()
    }
}

struct POSTUsoEquipos: Codable {
    let EquiposNombreEquipo: String
    let fechaInitBitUE: String
    let AlumnosIdAlumno: Int
    let muestraBitUE: String
    let condicionBitUE: String
    let fechaTermBitUE: String
}
