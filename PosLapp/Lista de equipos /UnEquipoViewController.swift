//
//  DetalleViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/18/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import Kingfisher

class DetalleViewController: UITableViewController {
    
    @IBOutlet var imagenEquipo: UIImageView!
    @IBOutlet var nombreEquipo: UILabel!
    @IBOutlet var modeloEquipo: UILabel!
    @IBOutlet var serieEquipo: UILabel!
    @IBOutlet var energiaEquipo: UILabel!
    @IBOutlet var descripcionEquipo: UILabel!
    
    @IBOutlet var detallesEquipo: UITextView!
    
    private var isRefreshing = true
    var unEquipo: ListaEquipos!
    
    override func viewWillAppear(_ animated: Bool) {
        var alimentacionE: Int = 0
         tableView.allowsSelection = false
        
        nombreEquipo.text = "Nombre: \(unEquipo.nombreEquipo)"
        modeloEquipo.text = "Modelo: \(unEquipo.modeloEquipo)"
        serieEquipo.text = "Número de serie: \(unEquipo.serieEquipo)"
        alimentacionE = unEquipo.alimElecEquipo
        energiaEquipo.text = "Alimentacion eléctrica: \(alimentacionE)"
        descripcionEquipo.text = "Disponibilidad: \(unEquipo.observacionesEquipo)"
        detallesEquipo.isEditable = false
        detallesEquipo.text = unEquipo?.observacionesEquipo
        
        imagenEquipo.kf.setImage(with: URL(string: unEquipo!.imagenEquipo))
    }
}

extension DetalleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//extension Date {
//    var formatted: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .long
//        return formatter.string(from: self)
//    }
//}
//
//extension DateFormatter {
//    static let fullISO8601: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter
//    }()
//}
//
extension Int {
    var formatted: String {
        let sign = self >= 0 ? "V" : ""
        return sign
    }
}
//
//extension Bool {
//    var formatted: String {
//        return self ? "Succeeded" : "Failed"
//    }
//}
