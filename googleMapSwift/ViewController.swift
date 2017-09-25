//
//  ViewController.swift//  googleMapSwift
//
//  Created by Intern on 18/09/17.
//  Copyright © 2017 Intern. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController,UISearchBarDelegate,LocateOnTheMap,GMSAutocompleteFetcherDelegate {
    var searchController : SearchResultsController!
    var result = [String]()
    @IBOutlet weak var mapview: UIView!
    var gmsafetcher : GMSAutocompleteFetcher!
    var gmsMapView : GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.gmsMapView = GMSMapView(frame: self.mapview.frame)
        self.view.addSubview(gmsMapView)
        searchController = SearchResultsController()
        searchController.delegate = self
        gmsafetcher = GMSAutocompleteFetcher()
        gmsafetcher.delegate = self
    }

    @IBAction func search(_ sender: Any) {
        let search = UISearchController(searchResultsController: searchController)
        search.searchBar.delegate = self
        self.present(search, animated: true, completion: nil)
    }
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.gmsMapView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.gmsMapView
            
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.result.removeAll()
        gmsafetcher?.sourceTextHasChanged(searchText)
       
}

    public func didFailAutocompleteWithError(_ error: Error) {
        
    }
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.result.append(prediction.attributedFullText.string)
            }
        }
        self.searchController.reloadDataWithArray(self.result)

    
    }
}
