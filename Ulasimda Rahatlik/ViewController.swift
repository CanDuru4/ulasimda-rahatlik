//
//  ViewController.swift
//  Ulasimda Rahatlik
//
//  Created by Can Duru on 7.01.2023.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase

struct Busses{
    let crowd: Int
    let latitude, longitude: Double
    let name: String
    let temperature: Int
}


class ViewController: UIViewController {
    
    //MARK: Init
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    var busses:[Busses] = [] {
        didSet{
            //MARK: Annotate Bus Locations
            for BusAnnotation in self.map.annotations {
                if let BusAnnotation = BusAnnotation as? CustomPointAnnotation, BusAnnotation.customidentifier == "busAnnotation" {
                    self.map.removeAnnotation(BusAnnotation)
                }
            }
            busLocations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        setMapLayout()
        mapLocation()
        setButton()
        BusData()
        busses = []
        map.delegate = self
    }
    

    //MARK: Current Location
    func mapLocation(){
        LocationManager.shared.getUserLocation { [weak self] location in DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
                strongSelf.map.showsUserLocation = true
            }
        }
    }
    
    
//MARK: Map Settings
    
    
    
    //MARK: Layout of the Map
    func setMapLayout(){
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([map.topAnchor.constraint(equalTo: view.topAnchor), map.bottomAnchor.constraint(equalTo: view.bottomAnchor), map.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), map.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)])
    }
    
    //MARK: Buttons of the Map
    let currentlocationButton = UIButton(type: .custom)
    let zoomOutButton = UIButton(type: .custom)
    let zoomInButton = UIButton(type: .custom)


    func setButton(){
        //MARK: Current Location Button
        currentlocationButton.backgroundColor = UIColor(white: 1, alpha: 0.8)
        currentlocationButton.setImage(UIImage(systemName: "location.fill")?.resized(to: CGSize(width: 25, height: 25)).withTintColor(.systemBlue), for: .normal)
        currentlocationButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        view.addSubview(currentlocationButton)
        
        currentlocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([currentlocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10), currentlocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60), currentlocationButton.widthAnchor.constraint(equalToConstant: 50), currentlocationButton.heightAnchor.constraint(equalToConstant: 50)])
        currentlocationButton.layer.cornerRadius = 25
        currentlocationButton.layer.masksToBounds = true
        
        //MARK: Zoom Out Button
        zoomOutButton.backgroundColor = UIColor(white: 1, alpha: 0.8)
        zoomOutButton.setImage(UIImage(systemName: "minus.square.fill")?.resized(to: CGSize(width: 25, height: 25)).withTintColor(.systemBlue), for: .normal)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        view.addSubview(zoomOutButton)
        
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([zoomOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10), zoomOutButton.bottomAnchor.constraint(equalTo: currentlocationButton.topAnchor, constant: -20), zoomOutButton.widthAnchor.constraint(equalToConstant: 50), zoomOutButton.heightAnchor.constraint(equalToConstant: 50)])
        zoomOutButton.layer.cornerRadius = 10
        zoomOutButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        //MARK: Zoom In Button
        zoomInButton.backgroundColor = UIColor(white: 1, alpha: 0.8)
        zoomInButton.setImage(UIImage(systemName: "plus.square.fill")?.resized(to: CGSize(width: 25, height: 25)).withTintColor(.systemBlue), for: .normal)
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        view.addSubview(zoomInButton)
        
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([zoomInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10), zoomInButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor), zoomInButton.widthAnchor.constraint(equalToConstant: 50), zoomInButton.heightAnchor.constraint(equalToConstant: 50)])
        zoomInButton.layer.cornerRadius = 10
        zoomInButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    //MARK: Current Location Button Action
    @objc func pressed() {
        zoom_count = 0
        LocationManager.shared.getUserLocation { [weak self] location in DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.map.setRegion(MKCoordinateRegion(center: location.coordinate, span:MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            }
        }
    }
    
    var zoom_count = 0
    //MARK: Zoom In Button Action
    @objc func zoomIn() {
        zoomMap(byFactor: 0.5)
        zoom_count = zoom_count-1
    }
    
    //MARK: Zoom Out Button Action
    @objc func zoomOut() {
        if zoom_count < 14 {
            zoomMap(byFactor: 2)
            zoom_count = zoom_count+1
        }
    }
    
    func zoomMap(byFactor delta: Double) {
        var region: MKCoordinateRegion = self.map.region
        var span: MKCoordinateSpan = map.region.span
        span.latitudeDelta *= delta
        span.longitudeDelta *= delta
        region.span = span
        map.setRegion(region, animated: true)
    }
    
    
//MARK: Getting Bus Data - Location, Temperature, Crowd
    
    //MARK: Bus Location Annotation
    var BusAnnotation: CustomPointAnnotation!
    var BusAnnotationView:MKPinAnnotationView!
    //MARK: Check and mark bus locations in every 15 second
    @objc func busLocations(){
        let busCount = busses.count
        for i in (0..<busCount){
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(busses[i].latitude), CLLocationDegrees(busses[i].longitude))
            let BusAnnotation = CustomPointAnnotation()
            BusAnnotation.coordinate = coordinate
            BusAnnotation.title = busses[i].name
            if (busses[i].crowd>50000){
                let crowdness = "Çok Kalabalık"
                BusAnnotation.subtitle = "Sıcaklık: \(String(busses[i].temperature)), \(crowdness)"
                BusAnnotation.customidentifier = "busAnnotation"
                map.addAnnotation(BusAnnotation)
            }
            else if 25000<busses[i].crowd{
                let crowdness = "Kalabalık"
                BusAnnotation.subtitle = "Sıcaklık: \(String(busses[i].temperature)), \(crowdness)"
                BusAnnotation.customidentifier = "busAnnotation"
                map.addAnnotation(BusAnnotation)
            }
            else {
                let crowdness = "Kalabalık Değil"
                BusAnnotation.subtitle = "Sıcaklık: \(String(busses[i].temperature)), \(crowdness)"
                BusAnnotation.customidentifier = "busAnnotation"
                map.addAnnotation(BusAnnotation)
            }
        }
    }
    
    //MARK: Bus Data
    var timer = Timer()
    func BusDataRepeat(){
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            self.BusData()
        })
    }
    @objc func BusData(){
        let ref = Database.database().reference().child("Busses")
        var name = ""
        var crowd = 0
        var latitude = 0.000
        var longitude = 0.000
        var temperature = 0
        
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                name = dict["name"] as! String
                temperature = dict["temperature"] as! Int
                crowd = dict["crowd"] as! Int
                latitude = dict["latitude"] as! Double
                longitude = dict["longitude"] as! Double
                
                self.busses.append(Busses(crowd: crowd, latitude: latitude, longitude: longitude, name: name, temperature: temperature))
            }
        }
    }
}



//MARK: Extension
extension UIImage {
    public func resized(to target: CGSize) -> UIImage {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let new = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}



//MARK: Pin With Image Extension
extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?  {
        
        guard let annotation = annotation as? CustomPointAnnotation else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "reuseIdentifier")
            annotationView?.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        
        //MARK: Bus Annotation
        if annotation.customidentifier == "busAnnotation" {
            annotationView?.image = UIImage(systemName: "bus")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue).resized(to: CGSize(width: 20, height: 20))
        }
        
        //MARK: Selected Bus Annotation
        if annotation.customidentifier == "selectedBusAnnotation" {
            annotationView?.image = UIImage(systemName: "bus")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue).resized(to: CGSize(width: 20, height: 20))
        }

        return annotationView
    }
    
    
    
    //MARK: Select Annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)  {
        let annotation = view.annotation as? CustomPointAnnotation
        
        if annotation?.customidentifier == "busAnnotation" {
            
        }
    }
}
