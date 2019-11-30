//
//  RegistrarAccesoViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/23/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class RegistrarAccesoViewController: UIViewController {
    
    var datePickerHoraE: UIDatePicker?
    @IBOutlet var fechaEntrada: UITextField!
    var datePickerHoraS: UIDatePicker?
    @IBOutlet var fechaSalida: UITextField!
    
    var AlumnoId: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        datePickerHora = UIDatePicker()
//        datePickerHora?.datePickerMode = .time
//        let currentDate = Date()
//        var dateComponents = DateComponents()
//        let calendar = Calendar.init(identifier: .gregorian)
//        dateComponents.minute = -15
//        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
//        dateComponents.minute = 0
//        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
//        datePickerHora?.maximumDate = maxDate
//        datePickerHora?.minimumDate = minDate
//        datePickerHora?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
//
//        datePickerHoraS = UIDatePicker()
//        datePickerHoraS?.datePickerMode = .time
//        let currentDate2 = Date()
//        var dateComponents2 = DateComponents()
//        let calendar2 = Calendar.init(identifier: .gregorian)
//        dateComponents2.minute = 0
//        let minDate2 = calendar.date(byAdding: dateComponents2, to: currentDate2)
//        dateComponents2.minute = 15
//        let maxDate2 = calendar2.date(byAdding: dateComponents2, to: currentDate2)
//        datePickerHoraS?.maximumDate = maxDate2
//        datePickerHoraS?.minimumDate = minDate2
//        datePickerHoraS?.addTarget(self, action: #selector(dateChanged2(datePicker:)), for: .valueChanged)
        
        
        datePickerHoraE = UIDatePicker()
        datePickerHoraE?.datePickerMode = .time
        let cal = Calendar.current
        let now = Date()  // get the current date and time (2018-03-27 19:38:44)
        let components = cal.dateComponents([.day, .month, .year], from: now)  // extract the date components 28, 3, 2018
        let today = cal.date(from: components)!  // build another Date value just with date components, without the time (2018-03-27 00:00:00)
        datePickerHoraE?.minimumDate = today.addingTimeInterval(60 * 60 * 8)  // adds 9h
        datePickerHoraE?.maximumDate = today.addingTimeInterval(60 * 60 * 18) // adds 21h
        datePickerHoraE?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        datePickerHoraS = UIDatePicker()
        datePickerHoraS?.datePickerMode = .time
        let cal2 = Calendar.current
        let now2 = Date()
        let components2 = cal2.dateComponents([.day, .month, .year], from: now2)
        let today2 = cal2.date(from: components2)!
        datePickerHoraS?.minimumDate = today2.addingTimeInterval(60 * 60 * 8)
        datePickerHoraS?.maximumDate = today2.addingTimeInterval(60 * 60 * 18)
        datePickerHoraS?.addTarget(self, action: #selector(dateChanged2(datePicker:)), for: .valueChanged)

        fechaEntrada.inputView = datePickerHoraE
        fechaSalida.inputView = datePickerHoraS
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, HH:mm"
            
        fechaEntrada.text = dateFormatter.string(from: datePicker.date)
    //    view.endEditing(false)
        }
    
    @objc func dateChanged2(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, HH:mm"
        fechaSalida.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func guardarAcceso(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, HH:mm"
        let firstDate = formatter.date(from: fechaEntrada.text!)
        let secondDate = formatter.date(from: fechaSalida.text!)

        if firstDate?.compare(secondDate!) == .orderedSame {
            print("Las fechas son similares")
            self.displayMessage(userMessage: "La fecha de entrada y salida no pueden ser iguales")
        }
            
        else if firstDate?.compare(secondDate!) == .orderedDescending {
            print("La fecha de entrada no puede ser mayor a la de salida")
            self.displayMessage(userMessage: "La fecha de entrada no puede ser mayor a la de salida")
        }
        
        else {
            let alumnoId: String! = KeychainWrapper.standard.string(forKey: "AlumnoId")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, HH:mm"
        let date = dateFormatter.date(from: fechaEntrada.text!)

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let goodDate = dateFormatter.string(from: date!)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MMM/yyyy, HH:mm"
        let date2 = dateFormatter2.date(from: fechaSalida.text!)

        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let goodDate2 = dateFormatter2.string(from: date2!)
        
        print(goodDate)
        print(goodDate2)
        
        //guard let myUrl = URL(string: "http://192.168.137.139:10010/bitacoraAccesos")
        guard let myUrl = URL(string: "http://192.168.1.65:10010/bitacoraAccesos")
            else {return}
                var request = URLRequest(url: myUrl)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
       
        let newPost = POSTAccesoBitacora(AlumnosIdAlumno: Int(alumnoId)!, fechaInitBitAc: goodDate, fechaFinBitAc: goodDate2)
                do {
                    let jsonBody = try JSONEncoder().encode(newPost)
                    request.httpBody = jsonBody
                } catch {print("1")
                    self.displayMessage(userMessage: "Algun problema ocurrio. Vuelve a intentarlo")
                    print(request)
                    print(error)}
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (data, request, error) in
                    guard let data = data else {return}
                    do {
                        let sentPost = try [JSONDecoder().decode(POSTApartados.self, from: data)]
                        print(sentPost)
                        self.displayMessage(userMessage: "Tu registro de acceso a sido registrado exitosamente")
                    } catch {
                        self.displayMessage(userMessage: "Algun problema ocurrio. Vuelve a intentarlo")
                        print("2")
                        print(request)
                        print(error)
                    }
                }
                task.resume()
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

struct POSTAccesoBitacora: Codable {
    let AlumnosIdAlumno: Int
    let fechaInitBitAc: String
    let fechaFinBitAc: String
    
    enum Codingkeys: String, CodingKey {
        case AlumnosIdAlumno = "AlumnosIdAlumno"
        case fechaInitBitAc = "fechaInitBitAc"
        case fechaFinBitAc = "fechaFinBitAc"
    }
}
