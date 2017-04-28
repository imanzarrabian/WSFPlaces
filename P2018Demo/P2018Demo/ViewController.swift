//
//  ViewController.swift
//  P2018Demo
//
//  Created by Iman Zarrabian on 24/04/2017.
//  Copyright © 2017 One More Thing Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var colorButton: UIButton!

    let arrayOfColors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.layer.cornerRadius = 10.0
        customView.layer.masksToBounds = true
    }

    @IBAction func buttonPushed(_ sender: UIButton) {
        let index = Int(arc4random() % 4)
        let selectedColor = arrayOfColors[index]
            
        customView.backgroundColor = selectedColor
        colorButton.setTitle(customView.backgroundColor?.description, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("low memory received")
    }


}

