//
//  BotonAyuda.swift
//  PosLapp
//
//  Created by Administrador on 10/29/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class BotonAyuda: UIViewController {

    @IBAction func btnAyuda(_ sender: Any) {
        guard let number = URL(string:"tel://"+"2225548469") else{return}
        UIApplication.shared.open(number)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
