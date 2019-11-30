//
//  RatingViewController.swift
//  PosLapp
//
//  Created by Administrador on 11/29/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import UIKit

class RatingViewController: UIStackView {
    var starsRating = 0
    var starsEmptyPicName = "estrellaVacia"
    var starsFilledName = "estrellaLlena"
    
    override func draw(_ rect: CGRect) {
        let myViews =   self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for theView in myViews {
            if let theButton = theView as? UIButton {
                theButton.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                theButton.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
                theButton.tag = starTag
                starTag = starTag + 1
            }
        }
    }
    
    @objc func pressed(sender: UIButton){
        starsRating = sender.tag
        let myViews = self.subviews.filter{$0 is UIButton}
        for theView in myViews {
            if let theButton = theView as? UIButton {
                if theButton.tag > sender.tag {
                    theButton.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                } else {
                    theButton.setImage(UIImage(named: starsFilledName), for: .normal)
                }
            }
        }
    }
}
