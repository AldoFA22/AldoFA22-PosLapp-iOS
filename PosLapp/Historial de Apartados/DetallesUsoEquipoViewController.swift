//
//  DetallesViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/12/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class DetallesUsoEquipoViewController: UIViewController {
    //Variables Detalles de Apartado
    @IBOutlet var zona: UILabel!
    @IBOutlet var equipo: UILabel!
    @IBOutlet var muestra: UILabel!
    @IBOutlet var condicion: UILabel!
    @IBOutlet var fechainit: UILabel!
    @IBOutlet var fechaFin: UILabel!
    
    var strzona = ""
    var strequipo = ""
    var strmuestra = ""
    var strcondicion = ""
    var strfechaInit = ""
    var strfechaFin = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zona.text = strzona
        equipo.text = strequipo
        muestra.text = strmuestra
        condicion.text = strcondicion
        fechainit.text = strfechaInit
        fechaFin.text = strfechaFin
        
       
//    imagenEquipo.kf.base.accessibilityValue?.append(contentsOf: strImagenEquipo)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
