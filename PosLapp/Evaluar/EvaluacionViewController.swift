//
//  EvaluacionViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/29/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class EvaluacionViewController: UIViewController {

    @IBOutlet var ratingStackView: RatingViewController!
    var noEstrellas = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func evaluar(_ sender: Any) {
        print("Estrellas: \(noEstrellas)")
        noEstrellas = ratingStackView.starsRating
        print(ratingStackView.starsRating)
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
