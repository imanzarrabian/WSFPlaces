//
//  PlaceDetailViewController.swift
//  WSFPlaces
//
//  Created by Iman Zarrabian on 27/04/2017.
//  Copyright © 2017 One More Thing Studio. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    var place: Place!
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let titleDict = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        title = place.name
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        updateUI()
        fetchReviews()
    }
    
    
    func updateUI() {
        let center = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lng)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        addressLabel.text = place.address
    }
    

    func fetchReviews() {
        let params = ["placeid": place.id,
                      "key" : Constants.Google.key] as [String : Any]
        
        Alamofire.request(Constants.Google.detailURL,
                     parameters: params,
                     encoding: URLEncoding.default).responseJSON { response in
                        
                        switch response.result {
                        case .success: //201 HTTP
                            guard
                                let rootJson = response.result.value as? [String: Any],
                                // on a bien un dict [String: Any] à la racine
                                let resultsJson = rootJson["result"] as? [String: Any],
                                // on bien un element "results" à la racine qui est dictionnaire [String: Any]
                                let reviewsJson = resultsJson["reviews"] as? [[String: Any]]
                                // on bien un element "reviews" dans "reviews" qui est tableau de [String: Any]

                                else {
                                    //sinon on peut rien faire
                                    print("cannot be parsed")
                                    return
                            }
                            
                            //LE GUARD S'EST BIEN PASSÉ
                            //Map or For-Loop
                            self.reviews = reviewsJson.map { Review(json: $0) }
                            self.reviewsTableView.reloadData()

                        case .failure:
                            print("FAILED REQUEST")
                        }
                        
        }
    }
}

extension PlaceDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.authorLabel.text = reviews[indexPath.row].authorName
        cell.ratingLabel.text = "\(reviews[indexPath.row].rating)/5.0"
        
        cell.relativeTimeDescription.text = reviews[indexPath.row].relativeTimeDescription
        Alamofire.request(reviews[indexPath.row].authorPhotoUrl).responseImage { (image) in
            cell.avatarIV.image = image.result.value
        }
        return cell
    }
}

extension PlaceDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let review = reviews[indexPath.row]
        let alert = UIAlertController(title: review.authorName, message: review.text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}



