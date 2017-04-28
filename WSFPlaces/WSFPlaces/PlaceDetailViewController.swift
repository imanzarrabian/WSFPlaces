//
//  PlaceDetailViewController.swift
//  WSFPlaces
//
//  Created by Iman Zarrabian on 27/04/2017.
//  Copyright © 2017 One More Thing Studio. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let titleDict = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        title = place.name
    }
}
