//
//  SecondViewController.swift
//  PosLapp
//
//  Created by Administrador on 10/2/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class CerrarSesionViewController: UIViewController {

    @IBOutlet var nombreLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var fechaNacimientoLabel: UILabel!
    @IBOutlet var telefonoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemberProfile()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "UsuarioId")
        KeychainWrapper.standard.removeObject(forKey: "nombre")
        KeychainWrapper.standard.removeObject(forKey: "Rol")
        KeychainWrapper.standard.removeObject(forKey: "AlumnoId")
            
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "ReiniciarViewController") as! ReiniciarViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
    
    func loadMemberProfile() {
        let accessToken: String! = KeychainWrapper.standard.string(forKey: "accessToken")
        let alumnoId: String! = KeychainWrapper.standard.string(forKey: "AlumnoId")
        let nombre: String! = KeychainWrapper.standard.string(forKey: "nombre")
        let rol: String! = KeychainWrapper.standard.string(forKey: "Rol")
        let usuarioId: String! = KeychainWrapper.standard.string(forKey: "UsuarioId")
        
        print("Access token:")
        print(accessToken)
        print("AlumnoId")
        print(alumnoId)
        print("nombre:")
        print(nombre)
        print("rol")
        print(rol)
        print("usuarioId")
        print(usuarioId)

        //Mandar peticion http para obtener datos del usuario
        guard let myUrl = URL(string: "http://10.50.93.30:10010/usuarios/\(usuarioId!)")
//        guard let myUrl = URL(string: "http://192.168.1.91:10010/Usuarios/\(usuarioId!)")
        else {return}
        var request = URLRequest(url: myUrl)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response:URLResponse?, error:Error?) in

            if error != nil{
                self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later1")
                print("error=\(String(describing:error))")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    DispatchQueue.main.async {
                        let firstName:String? = parseJSON["nombreUsuario"] as? String
                        let lastName:String? = parseJSON["apellido"] as? String
                        let email: String? = parseJSON["email"] as? String
                        let fechaNacimiento:String? = parseJSON["fechaNacimiento"] as? String
                        let telefono: String? = parseJSON["telefono"] as? String

                        if firstName?.isEmpty == true || lastName?.isEmpty == true || email?.isEmpty == true || fechaNacimiento?.isEmpty == true || telefono?.isEmpty == true{
                            self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later")
                        }
                        else if firstName?.isEmpty != true || nombre?.isEmpty != true || rol?.isEmpty != true || alumnoId?.isEmpty != true || fechaNacimiento?.isEmpty != true || telefono?.isEmpty != true{
                            self.nombreLabel.text! = nombre!
                            self.emailLabel.text! = email!
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "es_ES")
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                            let date = dateFormatter.date(from: fechaNacimiento!)
                            dateFormatter.dateFormat = "dd 'de' MMMM, yyyy"
                            let goodDate = dateFormatter.string(from: date!)
                            
                            self.fechaNacimientoLabel.text! = goodDate
                            self.telefonoLabel.text! = telefono!
                        }
                    }
                }
                else {
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please ty again later2")
                }

            } catch {
                self.displayMessage(userMessage: "No se pudo realizar la solicitud. Favor de intentarlo nuevamente")
                print(error)
            }
        }
        task.resume()
        
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
