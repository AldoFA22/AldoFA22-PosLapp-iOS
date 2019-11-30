//
//  ApartarEspacioViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/18/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import UIKit

struct ProfesorResponsable: Decodable{
    let Usuario: UsuarioAlumno
    let id: Int
}

struct Alumnos: Decodable{
    let Usuario: UsuarioAlumno
    let id: Int
}

struct UsuarioAlumno: Decodable {
//    let id: Int
    let nombreUsuario: String
    let apellido: String
}

struct Zona: Decodable {
    let id: Int
    let nombreZona: String
}


class ApartarEspacioViewController: UIViewController,
UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var alumnoResponsable: UITextField!
    @IBOutlet weak var profesorResponsable: UITextField!
    @IBOutlet weak var gradoObtener: UITextField!
    @IBOutlet weak var gradoSeg: UISegmentedControl!
    
    @IBOutlet weak var documentoGenerar: UITextField!
    
    @IBOutlet weak var documentoSeg: UISegmentedControl!
    
    
    @IBOutlet weak var proyectoRealizar: UITextField!
    
    @IBOutlet weak var proyectoSeg: UISegmentedControl!
    
    
    @IBOutlet weak var decripcionApartar: UITextField!
    
    @IBOutlet weak var tipoZona: UITextField!
    
    
    @IBOutlet weak var fechaInicio: UITextField!
    @IBOutlet weak var horaInicio: UITextField!
    @IBOutlet weak var fechaFin: UITextField!
    @IBOutlet weak var horaFin: UITextField!
    
    @IBOutlet weak var zonaLab: UITextField!
    
    private var datePickerFecha: UIDatePicker?
    private var datePickerHora: UIDatePicker?
    private var datePicker2fecha: UIDatePicker?
    private var datePicker2Hora: UIDatePicker?
    
    private var AlumnoSolicitanteId: Int = 0
    private var ProfesorResponsableId: Int = 0
    private var ZonaId: Int = 0
    
    var grado = ["Licenciatura","Maestria","Doctorado"]
    var documento = ["Tesis","Reporte","Artículo"]
    var proyecto = ["Tesis","Servicio Social","Práctica profesional","Estancia","Práctica de curso"]
    var zona = ["No restringida","Parcialmente restringida","Restringida"]
    
    var profesor = [ProfesorResponsable]()
    var alumnos = [Alumnos]()
    var usuario = [UsuarioAlumno]()
    var zonas = [Zona]()

override func viewDidLoad() {
    super.viewDidLoad()
    let modelPickerView = UIPickerView()
    modelPickerView.delegate = self
    modelPickerView.tag = 1
    alumnoResponsable.inputView = modelPickerView
    
    let modelPickerView2 = UIPickerView()
    modelPickerView2.delegate = self
    modelPickerView2.tag = 2
    profesorResponsable.inputView = modelPickerView2
    
    let modelPickerView3 = UIPickerView()
    modelPickerView3.delegate = self
    modelPickerView3.tag = 3
    zonaLab.inputView = modelPickerView3
    
    let modelPickerView4 = UIPickerView()
    modelPickerView4.delegate = self
    modelPickerView4.tag = 4
    gradoObtener.inputView = modelPickerView4
    
    let modelPickerView5 = UIPickerView()
    modelPickerView5.delegate = self
    modelPickerView5.tag = 5
    documentoGenerar.inputView = modelPickerView5
    
    let modelPickerView6 = UIPickerView()
    modelPickerView6.delegate = self
    modelPickerView6.tag = 6
    proyectoRealizar.inputView = modelPickerView6
    
    datePickerHora = UIDatePicker()
    datePickerHora?.datePickerMode = .time
    let cal = Calendar.current
    let now = Date()  // get the current date and time (2018-03-27 19:38:44)
    let components = cal.dateComponents([.day, .month, .year], from: now)  // extract the date components 28, 3, 2018
    let today = cal.date(from: components)!  // build another Date value just with date components, without the time (2018-03-27 00:00:00)
    datePickerHora?.minimumDate = today.addingTimeInterval(60 * 60 * 9)  // adds 9h
    datePickerHora?.maximumDate = today.addingTimeInterval(60 * 60 * 16) // adds 21h
    datePickerHora?.minuteInterval = 15
    datePickerHora?.addTarget(self, action: #selector(dateChanged3(datePicker:)), for: .valueChanged)
    
    datePickerFecha = UIDatePicker()
    datePickerFecha?.minimumDate = Date()
    datePickerFecha?.minuteInterval = 15
    datePickerFecha?.datePickerMode = .date
    datePickerFecha?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
    
    datePicker2Hora = UIDatePicker()
    datePicker2Hora?.datePickerMode = .time
    let cal2 = Calendar.current
    let now2 = Date()
    let components2 = cal.dateComponents([.day, .month, .year], from: now2)
    let today2 = cal2.date(from: components2)!
    datePicker2Hora?.minimumDate = today2.addingTimeInterval(60 * 60 * 9)
    datePicker2Hora?.maximumDate = today2.addingTimeInterval(60 * 60 * 16)
    datePicker2Hora?.minuteInterval = 15
    datePicker2Hora?.addTarget(self, action: #selector(dateChanged4(datePicker:)), for: .valueChanged)
    
    datePicker2fecha = UIDatePicker()
    datePicker2fecha?.minimumDate = Date()
    datePicker2fecha?.minuteInterval = 15
    datePicker2fecha?.datePickerMode = .date
    datePicker2fecha?.addTarget(self, action: #selector(dateChanged2(datePicker:)), for: .valueChanged)
           
    fechaInicio.inputView = datePickerFecha
    horaInicio.inputView = datePickerHora
    fechaFin.inputView = datePicker2fecha
    horaFin.inputView = datePicker2Hora
    
    self.hideKeyboardWhenTappedAround()
    
    let url = URL(string: "http://10.50.93.30:10010/getCorreos/Alumno")
 //   let url = URL(string: "http://192.168.1.73:10010/getCorreos/Alumno")

    URLSession.shared.dataTask(with: url!) { (data, response, err) in
        if err == nil {
            do{
                try self.alumnos = JSONDecoder().decode([Alumnos].self, from: data!)
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
    
    let url2 = URL(string: "http://10.50.93.30:10010/getCorreos/Profesor")
 //   let url2 = URL(string: "http://192.168.1.73:10010/getCorreos/Profesor")

    URLSession.shared.dataTask(with: url2!) { (data, response, err) in
        if err == nil {
            do{
               try self.profesor = JSONDecoder().decode([ProfesorResponsable].self, from: data!)
                //print(self.profesor)
            }catch{
                print("Parse error")
                print(error)
            }
            DispatchQueue.main.async {
            //    self.pickerview.reloadComponent(0)
            }
        }
    }.resume()
    
    let url3 = URL(string: "http://10.50.93.30:10010/zonas")
//    let url3 = URL(string: "http://192.168.1.73:10010/zonas")

    URLSession.shared.dataTask(with: url3!) { (data, response, err) in
        if err == nil {
            do{
               try self.zonas = JSONDecoder().decode([Zona].self, from: data!)
                print(self.zonas)
            }catch{
                print("Parse error")
                print(error)
            }
            DispatchQueue.main.async {
            //    self.pickerview.reloadComponent(0)
            }
        }
    }.resume()
}

@objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
    view.endEditing(false)
}
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        
        fechaInicio.text = dateFormatter.string(from: datePicker.date)
//    view.endEditing(false)
    }
    @objc func dateChanged2(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        fechaFin.text = dateFormatter.string(from: datePicker.date)
        
    }
    @objc func dateChanged3(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        horaInicio.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func dateChanged4(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        horaFin.text = dateFormatter.string(from: datePicker.date)

    }

    
//pickerview methods

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1;
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.tag == 1 {
        return alumnos.count
    }
    else if pickerView.tag == 2 {
        return profesor.count
    }
    else if pickerView.tag == 3 {
        return zona.count
    }
    else if pickerView.tag == 4 {
        return grado.count
    }
    else if pickerView.tag == 5 {
        return documento.count
    }
    else if pickerView.tag == 6 {
        return proyecto.count
    }
    
    return 0
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.tag == 1 {
        if alumnos.count > row{
        let nombre = alumnos[row].Usuario.nombreUsuario
        let apellido = alumnos[row].Usuario.apellido
        let nombreCompleto = nombre + " " + apellido
        return nombreCompleto
        }
    }
    else if pickerView.tag == 2 {
        if profesor.count > row{
        let nombre = profesor[row].Usuario.nombreUsuario
        let apellido = profesor[row].Usuario.apellido
        let nombreCompleto = nombre + " " + apellido
        return nombreCompleto
        }
    }
    else if pickerView.tag == 3 {
        if zonas.count > row{
        ZonaId = zonas[row].id
        return zona[row]
        }
    }
    else if pickerView.tag == 4 {
        return grado[row]
    }
    else if pickerView.tag == 5 {
        return documento[row]
    }
    else if pickerView.tag == 6 {
        return proyecto[row]
    }
    return nil
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.tag == 1 {
        if alumnos.count > row {
        let nombre = alumnos[row].Usuario.nombreUsuario
        let apellido = alumnos[row].Usuario.apellido
        let idAlumno = alumnos[row].id //PARAMETRO A POSTEAR YA FUNCIONA
        AlumnoSolicitanteId = idAlumno
        let nombreCompleto = nombre + " " + apellido
        alumnoResponsable.text = nombreCompleto
        view.endEditing(false)
        }
        else{
            print("No hay alumno")
        }
    }
    else if pickerView.tag == 2 {
        if profesor.count > row {
        let nombre = profesor[row].Usuario.nombreUsuario
        let apellido = profesor[row].Usuario.apellido
        let idProfesor = profesor[row].id //PARAMETRO A POSTEAR YA FUNCIONA
        ProfesorResponsableId = idProfesor
        let nombreCompleto = nombre + " " + apellido
        profesorResponsable.text = nombreCompleto
        view.endEditing(false)
        }
        else {
            print("No hay profesor")
        }
    }
    else if pickerView.tag == 3 {
        if zonas.count > row {
        let idZona = zonas[row].id //FUNCIONA
        ZonaId = idZona
        zonaLab.text = zona[row]
        view.endEditing(false)
        }
        else {
            print("No hay zona")
        }
    }
    else if pickerView.tag == 4 {
        gradoObtener.text = grado[row]
        view.endEditing(false)
    }
    else if pickerView.tag == 5 {
        documentoGenerar.text = documento[row]
        view.endEditing(false)
    }
    else if pickerView.tag == 6 {
        proyectoRealizar.text = proyecto[row]
        view.endEditing(false)
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
    
    @IBAction func gradoChanged(_ sender: Any) {
        print("grado changed")
        print(gradoSeg.selectedSegmentIndex)
        if gradoSeg.selectedSegmentIndex == 0{
            gradoObtener.text = nil
            let modelPickerView4 = UIPickerView()
            modelPickerView4.delegate = self
            modelPickerView4.tag = 4
            gradoObtener.inputView = modelPickerView4
            gradoObtener.reloadInputViews()
            gradoObtener.text = ""
            gradoObtener.placeholder = "Grado a obtener"
        }
        else if gradoSeg.selectedSegmentIndex == 1{
            gradoObtener.inputView = nil
            gradoObtener.reloadInputViews()
            gradoObtener.text = ""
            gradoObtener.placeholder = "Escribir otro grado"
        }
    }
    
    @IBAction func documentoChanged(_ sender: Any) {
        if documentoSeg.selectedSegmentIndex == 0{
            documentoGenerar.text = nil
            let modelPickerView5 = UIPickerView()
            modelPickerView5.delegate = self
            modelPickerView5.tag = 5
            documentoGenerar.inputView = modelPickerView5
            documentoGenerar.text = ""
            documentoGenerar.placeholder = "Documento a generar"
        }
        else if documentoSeg.selectedSegmentIndex == 1{
            documentoGenerar.inputView = nil
            documentoGenerar.reloadInputViews()
            documentoGenerar.text = ""
            documentoGenerar.placeholder = "Escribir otro tipo de documento"
        }
    }
    
    @IBAction func proyectoChanged(_ sender: Any) {
        if proyectoSeg.selectedSegmentIndex == 0{
            proyectoRealizar.text = nil
            let modelPickerView6 = UIPickerView()
            modelPickerView6.delegate = self
            modelPickerView6.tag = 6
            proyectoRealizar.inputView = modelPickerView6
            proyectoRealizar.text = ""
            proyectoRealizar.placeholder = "Proyecto a realizar"
        }
        else if proyectoSeg.selectedSegmentIndex == 1{
            proyectoRealizar.inputView = nil
            proyectoRealizar.reloadInputViews()
            proyectoRealizar.text = ""
            proyectoRealizar.placeholder = "Escribir otro proyecto"
        }
    }
    
    @IBAction func siguiente(_ sender: Any) {
        if alumnoResponsable.text != ""{
            performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var ListaEquiposController = segue.destination as! ListaBitApViewController
        ListaEquiposController.usuarioGet = alumnoResponsable.text!
        ListaEquiposController.usuarioGetId = AlumnoSolicitanteId
        ListaEquiposController.profesorGet = profesorResponsable.text!
        ListaEquiposController.profesorGetId = ProfesorResponsableId
        ListaEquiposController.gradoGet = gradoObtener.text!
        ListaEquiposController.documentoGet = documentoGenerar.text!
        ListaEquiposController.proyectoGet = proyectoRealizar.text!
        ListaEquiposController.descripcionGet = decripcionApartar.text!
        ListaEquiposController.fechaInicioGet = fechaInicio.text! + ", " + horaInicio.text!
        ListaEquiposController.fechaFinalGet = fechaFin.text! + ", " + horaFin.text!
        ListaEquiposController.zonaGet = zonaLab.text!
        ListaEquiposController.zonaGetId = ZonaId
        print("Si hay id \(AlumnoSolicitanteId)")
        print("Si hay id \(ProfesorResponsableId)")
        print("Si hay id \(ZonaId)")
    }
}

