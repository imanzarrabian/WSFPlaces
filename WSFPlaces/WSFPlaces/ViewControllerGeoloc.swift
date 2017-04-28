//
//  ViewController.swift
//  WSFPlaces
//
//  Created by Iman Zarrabian on 25/04/2017.
//  Copyright © 2017 One More Thing Studio. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreLocation


enum PlaceType: Int {
    case univerity = 0
    case food = 1
}

class ViewController: UIViewController {

    var places = [Place]() // aka => var places: [Place] = []
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var typeSelector: UISegmentedControl!
    @IBOutlet weak var placesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTableView.delegate = self
        placesTableView.dataSource = self
        
        handleLocation()
        
        if let location = locationManager?.location {
            fetchPlaces(ofType: .univerity, at: location)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func handleLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            //have to ask for authorisation
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func fetchPlaces(ofType type: PlaceType, at location: CLLocation) {

        var typeString: String
        switch type {
        case .univerity:
            typeString = "university"
        case .food:
            typeString = "food"
        }
        
        let locationString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        let params =
            ["location": locationString,
             "radius" : 500,
             "types": typeString,
             "key" : Constants.Google.key] as [String : Any]
        
        Alamofire
            .request(Constants.Google.baseURL,
                     parameters: params,
                     encoding: URLEncoding.default).responseJSON { response in
                        
                        switch response.result {
                        case .success: //201 HTTP
                            guard
                                let rootJson = response.result.value as? [String: Any],
                                // on a bien un dict [String: Any] à la racine
                                let placesJson = rootJson["results"] as? [[String: Any]]
                                // on bien un element "results" à la racine qui est un tableau de [String: Any]
                                
                                else {
                                    //sinon on peut rien faire
                                    print("cannot be parsed")
                                    return
                            }
                            
                            //LE GUARD S'EST BIEN PASSÉ
                            //Map or For-Loop
                            self.places = placesJson.map { Place(json: $0) }
                            
                        case .failure:
                            print("FAILED REQUEST")
                        }
                        
                        self.placesTableView.reloadData()
        }
    }
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        let type = PlaceType(rawValue: sender.selectedSegmentIndex)
        
        if let location = locationManager?.location {
            fetchPlaces(ofType: type!, at: location)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //passage de témoin
        //on donne un place au view controller de destination
        if segue.identifier == "DetailViewControllerSegue" {
            let cell = sender as! PlaceCell
            let indexPath = placesTableView.indexPath(for: cell)
            let place = places[indexPath!.row]
            
            let detailVC = segue.destination as! PlaceDetailViewController
            
            detailVC.place = place
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    //NB LIGNES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    //CONTENU de CHQ LIGNE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        cell.nameLabel.text = places[indexPath.row].name
        cell.addressLabel.text = places[indexPath.row].address
        
        Alamofire.request(places[indexPath.row].photo).responseImage { (image) in
            cell.photoIV.image = image.result.value
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse && CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager?.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
        if let location = locations.first {
            let type = PlaceType(rawValue: typeSelector.selectedSegmentIndex)

            self.fetchPlaces(ofType: type!, at: location)
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)

    }
}
