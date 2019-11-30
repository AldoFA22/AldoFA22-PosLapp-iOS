//
//  HisAccesoTableViewCell.swift
//  PosLapp
//
//  Created by Administrador on 11/12/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class DatosTableViewCell: UITableViewCell {
    //Variables Historial de Apartados
    @IBOutlet var apEntrada: UILabel!
    @IBOutlet var apSalida: UILabel!
    @IBOutlet var tipoZona: UILabel!
    
    //Variables Historial de Acceso
    @IBOutlet var fentrada: UILabel!
    @IBOutlet var fsalida: UILabel!
    
    //Variables Sobre el Equipo
    @IBOutlet var nombreEquipo: UILabel!
    @IBOutlet var modeloEquipo: UILabel!
    @IBOutlet var imagenEquipo: UIImageView!
    
    //Variables sobre Lista equipos
    @IBOutlet var listaEquipo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
