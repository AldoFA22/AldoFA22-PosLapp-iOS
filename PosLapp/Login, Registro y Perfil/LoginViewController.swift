//
//  ViewController.swift
//  PosLapp
//
//  Created by Administrador on 9/27/19.
//  Copyright © 2019 Administrador. All rights reserved.
//
import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    var UsuarioId: String! = ""
    var AlumnoId: String! = ""
    @IBOutlet weak var correoElectronico: UITextField!
    @IBOutlet weak var contraseña: UITextField!
    
    func validarCorreo(correo: String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let trimmedString = correo.trimmingCharacters(in: .whitespaces)
           let validarCorreo = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
           let isCorreoValido = validarCorreo.evaluate(with: trimmedString)
           return isCorreoValido
       }
       
//    func validarContraseña(contraseña : String) -> Bool {
//           let passRegEx = "(?=.*[A-Za-z0-9.-]).{8,16}"
//       //let passRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}"
//           let trimmedString = contraseña.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        //print(trimmedString)
//           let validarContraseña = NSPredicate(format: "SELF MATCHES %@", passRegEx)
//           let isContraValido = validarContraseña.evaluate(with: trimmedString)
//           return isContraValido
//       }
    
    @IBAction func iniciarSesion(_ sender: Any) {
        //Leer valores de los textfields
        let userName = correoElectronico.text
        let userPassword = contraseña.text
        
        guard let correo = correoElectronico.text, let contra = contraseña.text else {
        return
        }
        let isCorreoValido = self.validarCorreo(correo: correo)
        if (isCorreoValido == false){
            print("Incorrect email")
            return
        }
//        let isContraValido = self.validarContraseña(contraseña: contra)
//        if (isContraValido == false){
//            print("Incorrect password")
//            return
//        }
//        if (isCorreoValido == true || isContraValido == true){
//            print("Los campos son correctos")
//           // performSegue(withIdentifier: "login", sender: nil)
//        }
    print("Sign in button tapped")
            
            //Validar si alguno de los campos esta vacio
        if (userName?.isEmpty)! || (userPassword?.isEmpty)! {
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "Uno de los campos requeridos faltan en llenarse")
            return
        }
            
            //Crear indicador de actividad
        let myActivityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
                   
            //Posicion del indicador en el storyboard
        myActivityIndicator.center = view.center
                   
            //Evitar que este escondido
        myActivityIndicator.hidesWhenStopped = false
                   
            //Comenzar indicador
        myActivityIndicator.startAnimating()
            view.addSubview(myActivityIndicator)
            
            //Mandar Peticion HTTP al registro de usuario
        //let myUrl = URL(string: "http://192.168.1.91:10010/login/Alumno")
        let myUrl = URL(string: "http://10.50.93.30:10010/login/Alumno")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
            
        let postString = ["email":userName!, "password":userPassword!] as [String:String]
            
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)//Convertimos el diccionario a formato Json
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong...")
            return
        }
            
        let task = URLSession.shared.dataTask(with: request) {(data:Data?, response:URLResponse?,error:Error?) in
                
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
            if error != nil{
                self.displayMessage(userMessage: "No hubo respuesta del servidor. Por favor, vuelve a intentarlo más tarde.")
                print("error=\(String(describing:error))")
                return
            }
            print("Data")
            print(data)
            print("Response")
            print(response)
            print("Error")
            print(error)
                //Conertir respuesta de un codigo de servidor a un objeto NSDiccionario
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                if let parseJSON = json {
                    
                    guard let accessToken = parseJSON["token"] as? String else {return }
                    let alumnoId = parseJSON["id"] as? Int
                    let nombre = parseJSON["nombre"] as? String
                    let rol = parseJSON["Rol"] as? String
                    let usuarioId = parseJSON["idUsuario"] as? Int
                    print("Access token: = \(String(describing: accessToken))")
                    print("Alumno Id: = \(String(describing: alumnoId))")
                    print("Alumno nombre: = \(String(describing: nombre))")
                    print("Rol: = \(String(describing: rol))")
                    print("Id Usuario: = \(String(describing: usuarioId))")
                        
//                        Se crean dos variables para validar si el id del usuario y el token se han guardado
                    let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
                    
                    self.UsuarioId = "\(usuarioId!)"
                    let saveid: Bool = KeychainWrapper.standard.set(self.UsuarioId!, forKey: "UsuarioId")
                    
                    self.AlumnoId = "\(alumnoId!)"
                    let saveuserId: Bool = KeychainWrapper.standard.set(self.AlumnoId!, forKey: "AlumnoId")
                    
                    let saveNombre: Bool = KeychainWrapper.standard.set(nombre!, forKey: "nombre")
                    let saveRol: Bool = KeychainWrapper.standard.set(rol!, forKey: "Rol")
                    
                    print("The access token save result: \(saveAccessToken)"+" "+accessToken)
                    print("The usuarioId save result: \(saveid)" + " " + self.UsuarioId!)
                    print("The alumnoId save result: \(saveuserId)"+" "+self.AlumnoId!)
                    print("The name save result: \(saveNombre)")
                    print("The rol save result: \(saveRol)")
                        
                    DispatchQueue.main.async {
                        let homepage = self.storyboard?.instantiateViewController(withIdentifier: "SesionIniciadaViewController") as! SesionIniciadaViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homepage
                    }
                    if(accessToken.isEmpty){
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    }
                }
                else{
                        
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later3")
                }
            } catch{
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
            self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later4")
            }
        }
        task.resume()
    }
    
    @IBAction func registrarCuenta(_ sender: Any) {
        print("Register account button tapped")
        
//        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegistroViewController") as! RegistroViewController
//
//        self.present(registerViewController, animated:  true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        correoElectronico = textField(textfield: correoElectronico!, isSecure: false, maxLength: 20, minLength: 1)
        
        contraseña = textField(textfield: contraseña!, isSecure: true, maxLength: 16, minLength: 1)
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
}


extension UIViewController{
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
}


