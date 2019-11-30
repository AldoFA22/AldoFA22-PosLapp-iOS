//
//  RegistroViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/7/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import UIKit

struct CorreoValido: Codable{
    let Usuario: UsuarioEmail
    let sistema: String
}

struct UsuarioEmail: Codable{
    let email: String
}

class RegistroViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nombreReg: UITextField!
    @IBOutlet weak var apellidoReg: UITextField!
    @IBOutlet weak var correoElectronicoReg: UITextField!
    @IBOutlet weak var contraseñaReg: UITextField!
    @IBOutlet weak var conContraseñaReg: UITextField!
    @IBOutlet weak var telefonoReg: UITextField!
    @IBOutlet weak var fechaNacimiento: UITextField!
    @IBOutlet weak var institucionProcedenciaReg: UITextField!
    @IBOutlet weak var rolReg: UITextField!
    @IBOutlet weak var gradoReg: UITextField!
    
    var idInstitucion: Int = 0
    var institucion = ["Itesm Campus Puebla"]
    var idRoles: Int = 0
    var rol = ["Alumno","Profesor"]
    var gradoEscolar = ["Licenciatura","Especialidad","Maestria","Doctorado"]
    var lowercaseGrado: String = ""
    var arrdata = [CorreoValido]()
    var correoRecibido: String = ""
    var nuevoCorreo: Bool = false
    
    @IBOutlet weak var checkBoxButton: UIButton!
    private var datePicker: UIDatePicker?
    
    func validarNombre(nombre: String) -> Bool {
        let nombreRegex = "(?=.*[A-Z])(?=.*[a-z]).{3,18}$"
        let trimmedString = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let validarNombre = NSPredicate(format: "SELF MATCHES %@", nombreRegex)
        let isNombreValido = validarNombre.evaluate(with: trimmedString)
        return isNombreValido
    }
    
    func validarApellido(apellido: String) -> Bool {
        let apellidoRegex = "(?=.*[A-Z])(?=.*[a-z]).{3,18}"
        let trimmedString = apellido.trimmingCharacters(in: .whitespacesAndNewlines)
        let validarApellido = NSPredicate(format: "SELF MATCHES %@", apellidoRegex)
        let isApellidoValido = validarApellido.evaluate(with: trimmedString)
        return isApellidoValido
    }
    
    func validarColegio(colegio: String) -> Bool {
        let colegioRegex = "(?=.*[A-Za-z]).{3,60}"
        let validarColegio = NSPredicate(format: "SELF MATCHES %@", colegioRegex)
        let isColegioValido = validarColegio.evaluate(with: colegioRegex)
        return isColegioValido
    }
    
    func validarCorreo(correo: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = correo.trimmingCharacters(in: CharacterSet.whitespaces)
        //print(trimmedString)
        let validarCorreo = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        //print("checkpoint 1")
        let isCorreoValido = validarCorreo.evaluate(with: trimmedString)
        //print(isCorreoValido)
        return isCorreoValido
    }
       
    func validarContraseña(contraseña : String) -> Bool {
       let passRegEx = "(?=.*[A-Za-z0-9.-]).{8,16}"
        let trimmedString = contraseña.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let validarContraseña = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        let isContraValido = validarContraseña.evaluate(with: trimmedString)
        return isContraValido
       }
    
    func validarConfirmarContraseña(conContraseña: String) -> Bool {
        let passRegEx = "(?=.*[A-Za-z0-9.-]).{8,16}"
        let trimmedString = conContraseña.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let validarConContraseña = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        let isConContraValido = validarConContraseña.evaluate(with: trimmedString)
        return isConContraValido
    }
    
    func validarTelefono(telefono: String) -> Bool {
        let telefonoRegex = "^[0-9]\\d{9}$"
        let trimmedString = telefono.trimmingCharacters(in: .whitespaces)
        let validarTelefono = NSPredicate(format: "SELF MATCHES %@", telefonoRegex)
        let isTelefonoValido = validarTelefono.evaluate(with: trimmedString)
        return isTelefonoValido
    }
    
    @IBAction func registrarse(_ sender: Any) {
        //Crear indicador de actividad
        let myActivityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        
        //Posicion del indicador en el storyboard
        myActivityIndicator.center = view.center
        
        //Evitar que este escondido
        myActivityIndicator.hidesWhenStopped = false
        
        //Comenzar indicador
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        guard let nombre = nombreReg.text, let apellido = apellidoReg.text, let correo = correoElectronicoReg.text, let contra = contraseñaReg.text, let conContraseña = conContraseñaReg.text, let telefono = telefonoReg.text else {
            
        return
        }
        let isNombreValido = self.validarNombre(nombre: nombre)
        if (isNombreValido == false){
            print("Incorrect name")
            displayMessage(userMessage: "El nombre no es valido")
            return
        }
        let isApellidovalido = self.validarApellido(apellido: apellido)
        if (isApellidovalido == false){
            print("Incorrect apellido")
            displayMessage(userMessage: "Apellido no escrito correctamente")
            return
        }

        let isCorreoValido = self.validarCorreo(correo: correo)
        if (isCorreoValido == false){
            print("Incorrect email")
            displayMessage(userMessage: "Correo no valido")
            return
        }
        let isContraValido = self.validarContraseña(contraseña: contra)
        if (isContraValido == false){
            print("Incorrect password")
            displayMessage(userMessage: "Formato invalido de contraseña")
            return
        }
        let isConContraValido = self.validarConfirmarContraseña(conContraseña: conContraseña)
        if (conContraseña != contra){
            print("Las contraseñas no coinciden")
            displayMessage(userMessage: "Las contraseñas no coinciden")
            return
        }
        let isTelefonoValido = self.validarTelefono(telefono: telefono)
        if (isTelefonoValido == false){
            print("Incorrect telefono")
            displayMessage(userMessage: "Telefono incorrecto")
            return
        }
        if checkBoxButton.isSelected == false {
            displayMessage(userMessage: "No has aceptado los terminos y condiciones del servicio")
        }
        if (isNombreValido == true || isApellidovalido == true || isCorreoValido == true || isContraValido == true || isConContraValido == true || isTelefonoValido == true || checkBoxButton.isSelected == true){
            displayMessage(userMessage: "Registro exitoso")
            print("Los campos son correctos")
            //performSegue(withIdentifier: "login", sender: nil)
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        guard let date = dateFormatter.date(from: fechaNacimiento.text!) else {return}

        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nuevaFechaNacimiento = dateFormatter.string(from: (date))
        
        print(nombreReg.text!)
        print(apellidoReg.text!)
        print(correoElectronicoReg.text!)
        print(contraseñaReg.text!)
        print(nuevaFechaNacimiento)
        print(telefonoReg.text!)
        
        GETCorreo(correo: correoElectronicoReg.text!)
        
        print(nuevoCorreo)
        
        if nuevoCorreo != true{
            self.displayMessage(userMessage: "El correo ya existe, favor de registrarse con un nuevo correo")
        }
        
//        else if (nuevoCorreo == true) {
            
//            let myUrl = URL(string: "http://10.50.93.30:10010/usuarios")
//        //let myUrl = URL(string: "http://192.168.1.73:10010/usuarios")
//        var request = URLRequest(url:myUrl!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "content-type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let postString = ["nombreUsuario":nombreReg.text!,
//                "apellido":apellidoReg.text!,
//                "email":correoElectronicoReg.text!,
//                "password":contraseñaReg.text!,
//                "fechaNacimiento":nuevaFechaNacimiento,
//                "telefono":telefonoReg.text!] as [String:Any]
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)//Convertimos el diccionario a formato Json
//        } catch let error {
//            print("error" + error.localizedDescription)
//            displayMessage(userMessage: "Something wrong ocurred. Please try again1")
//            return
//        }
//
//        //Mandar http request
//        let task = URLSession.shared.dataTask(with: request) {(data:Data?, response:URLResponse?, error:Error?) in
//
//            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
//
//            if error != nil {
//                self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later2")
//                print("error=\(String(describing:error))")
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//
//                if let parseJSON = json {
//                    let userId = parseJSON["id"] as? Int
//                    print("User id: =\(String(describing:userId!))")
//
//                    if userId != nil {
//                            print(parseJSON)
//                        DispatchQueue.main.async { // Correct
//                           self.POSTAlumno(Usuarioid: userId!)
//                        }
//
//                       // self.displayMessage(userMessage: "User registered successfully. Please proceed to sign in4")
//                    }
//                    else {
//                        self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later3")
//                    }
//                }
//                else{
//                    self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later4")
//                }
//
//            } catch {
//                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
//                self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later6")
//            }
//            print("Aqui es: \(error)")
//            print(data)
//            print(response)
//        }
//        task.resume()
//        }
        
    }
    
    func GETCorreo(correo: String) {
//        print("Entra getCorreo")
//        print(correo)
//        let mensaje: Bool = false
//        let url3 = URL(string: "http://192.168.1.91:10010/AlumnosCorreo/\(correo)")
//        URLSession.shared.dataTask(with: url3!){ (data, response, error) in
//            do{if error == nil{
//                self.arrdata = [try
//                    JSONDecoder().decode(CorreoValido.self, from: data!)]
//
//                for mainarr in self.arrdata{
//                    print( ":", mainarr.Usuario.email)
//                    DispatchQueue.main.async {
//                       // self.view.reloadInputViews()
//                    }
//                }
//                }
//            }
//            catch{
//                print(data)
//                print(response)
//                print(error)
//            }
//        }.resume()
        print("Entra getCorreo")
        //create the url with NSURL
        //let url = URL(string: "http://192.168.1.91:10010/AlumnosCorreo/\(correo)")! //change the url
        let url = URL(string: "http://10.50.93.30:10010/AlumnosCorreo/\(correo)")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        let request = URLRequest(url: url)

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                    print(json)
                    DispatchQueue.main.async {
                    
                        let respuesta = "El correo no existe"
                        if json != ["Sistema": respuesta] {
                            print("SI existe el correo")
                            self.displayMessage(userMessage: "El correo ya existe, favor de registrarse con un nuevo correo")
                            self.nuevoCorreo = false

                        }
                        else if json == ["Sistema": respuesta] {
                            print("NO existe el correo")
                            self.nuevoCorreo = true
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func POSTAlumno(Usuarioid: Int){
        print("Aqui empieza post alumno")
        print(nombreReg.text!)
        print(apellidoReg.text!)
        print(correoElectronicoReg.text!)
        print(contraseñaReg.text!)
        print(fechaNacimiento.text!)
        print(telefonoReg.text!)
        print(institucionProcedenciaReg.text!)
        print(idInstitucion)
        print(rolReg.text!)
        print(idRoles)
        print(gradoReg.text!)

        //Crear indicador de actividad
        let myActivityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)

        //Posicion del indicador en el storyboard
        myActivityIndicator.center = view.center

        //Evitar que este escondido
        myActivityIndicator.hidesWhenStopped = false

        //Comenzar indicador
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)

//        let myUrl = URL(string: "http://192.168.1.73:10010/alumnos")
        let myUrl = URL(string: "http://10.50.93.30:10010/alumnos")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ["RolesIdRol":idRoles,
                "usuariosIdUsuarios":Usuarioid,
                "InstProcIdInstProc":idInstitucion,
                "gradoEscolarAlumnos":lowercaseGrado] as [String:Any]

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
                    self.displayMessage(userMessage: "Error 1001")
                    print("error=\(String(describing:error))")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                    if let parseJSON = json {
                        let AlumnoId = parseJSON["id"] as? Int
                        print("User id: =\(String(describing:AlumnoId!))")

                        if AlumnoId != nil {
                                print(parseJSON)
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
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later6")
                }
                print("Aqui es: \(error)")
                print(data)
                print(response)
            }
            task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let institucionPickerView = UIPickerView()
        institucionPickerView.delegate = self
        institucionPickerView.tag = 1
        institucionProcedenciaReg.inputView = institucionPickerView
        
        let rolPickerView = UIPickerView()
        rolPickerView.delegate = self
        rolPickerView.tag = 2
        rolReg.inputView = rolPickerView
        
        let gradoPickerView = UIPickerView()
        gradoPickerView.delegate = self
        gradoPickerView.tag = 3
        gradoReg.inputView = gradoPickerView
        
        datePicker = UIDatePicker()
        datePicker?.minuteInterval = 30
        
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -70
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = -17
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        datePicker?.maximumDate = maxDate
        datePicker?.minimumDate = minDate
                
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
                
        fechaNacimiento.inputView = datePicker
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
                
        view.addGestureRecognizer(tapGesture)
        self.hideKeyboardWhenTappedAround()
        
//        correoElectronicoReg = textField(textfield: correoElectronicoReg!, isSecure: false, maxLength: 30, minLength: 1)
        contraseñaReg = textField(textfield: contraseñaReg!, isSecure: true, maxLength: 16, minLength: 8)
        conContraseñaReg = textField(textfield: conContraseñaReg!, isSecure: true, maxLength: 16, minLength: 8)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        
           fechaNacimiento.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func textField(textfield: UITextField, isSecure: Bool, maxLength: Float, minLength: Float) -> UITextField{
        textfield.isSecureTextEntry = isSecure
        return textfield
    }
    
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
    
    @IBAction func checkBosTapped(_ sender: UIButton) {
        if sender.isSelected {
            checkBoxButton.isSelected = false
            print("checkbox empty")
        } else {
            checkBoxButton.isSelected = true
            print("checkbox full")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return institucion.count
        }
        else if pickerView.tag == 2 {
            return rol.count
        }
        else if pickerView.tag == 3 {
            return gradoEscolar.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return institucion[row]
        }
        else if pickerView.tag == 2 {
            return rol[row]
        }
        else if pickerView.tag == 3 {
            return gradoEscolar[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if institucion[row] == "Itesm Campus Puebla"{
                idInstitucion = 1
            }
            
            institucionProcedenciaReg.text! = institucion[row]
            print(idInstitucion)
            view.endEditing(true)
        }
        else if pickerView.tag == 2 {
            if rol[row] == "Alumno"{
                idRoles = 4
            }
            else if rol[row] == "Profesor"{
                idRoles = 3
            }
            
            rolReg.text! = rol[row]
            print(idRoles)
            view.endEditing(true)
        }
        else if pickerView.tag == 3 {
            lowercaseGrado = gradoEscolar[row].lowercased()
            gradoReg.text! = gradoEscolar[row]
            print(lowercaseGrado)
            view.endEditing(true)
        }
    }
}

