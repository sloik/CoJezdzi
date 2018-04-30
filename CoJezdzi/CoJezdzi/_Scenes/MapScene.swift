import MapKit
import UIKit
import ReSwift

struct PayloadData {
    let busses: [TData]
    let trams: [TData]
    
    var all: [TData] {
        return busses + trams
    }
    
    var count: Int {
        return busses.count + trams.count
    }
}

extension SettingsPersistance {
    var cityApiDealer: DataPullerDataProvider {
        get {
            return WarsawApiDealer()
        }
    }
}

class MapScene: UIViewController, LinesProvider {

    // MARK: - UI
    @IBOutlet weak var copyrightLable: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showCurrentLocationButton: UIButton?
    @IBOutlet weak var userSettingsButton: UIButton!
    @IBOutlet weak var refreshMapDataButton: UIButton!

    @IBOutlet weak var timeIndycatorRight: NSLayoutConstraint?
    @IBOutlet weak var timeIndycatorView: UIView?

    // MARK: -
    fileprivate let locationManager: CLLocationManager
    fileprivate let persisatance: SettingsPersistance

    fileprivate weak var settingsVC: SettingsVC?

    fileprivate var processDataDate = Date()

    var typeTLines: [String] {
        if let hasLaytestData = latestData?.all {
            return hasLaytestData.map{ (data: TData) -> String in
                return data.lines
            }
        }
        else {
            return []
        }
    }

    var latestData  : PayloadData?
    var previousData: PayloadData?

    required init?(coder aDecoder: NSCoder) {
        locationManager = CLLocationManager.init()
        persisatance = SettingsPersistance.init(defaults: UserDefaults.standard)
        
        super.init(coder: aDecoder)
        
        persisatance.eventDelegate = self
        locationManager.delegate = self

        NotificationCenter.default.addObserver(self,
                                             selector: #selector(invalidateTramsPosytionMarkers),
                                             name: NSNotification.Name.UIApplicationDidBecomeActive,
                                             object: nil)

    }

    fileprivate func handleUpdate(trams: [TData], busses: [TData]) {

        previousData = latestData
        latestData   = PayloadData(busses: busses, trams: trams)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()

        mapView.delegate = self

        styleSettingsButton()
        styleCurrentLocationButton()
        styleRefreshMapDataButton()

        zoomMapOnTheCity()
        zoomOnUserLocationIfNotShity()

        timeIndycatorView?.backgroundColor = UIColor.grape()
        
        store.dispatch(FetchTramsAction.fetch)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        store.subscribe(self)
        
        store.dispatch(RoutingAction(destination: .map))
        
        invalidateTramsPosytionMarkers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }

    // MARK: - Naviagation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.Storyboard.SegueID.ShowSettings {
            let settingsVC = (segue.destination as! UINavigationController).topViewController as! SettingsVC
            settingsVC.tLinesProvider = self
            settingsVC.persisatance = persisatance

            self.settingsVC = settingsVC
        }
        else if segue.identifier == C.Storyboard.SegueID.ShowWebAPIForm {
            let webScene = segue.destination as! WebScene
            webScene.goToURLString = C.Networking.GoToURL.APIUMWarszawa
        }
    }
}

extension MapScene: SettingsEvent {
    func settingsPersistanceDidPersist(_ persistance: SettingsPersistance) {
        
        if let latestData = latestData {
            processData(trams: latestData.trams, busses: latestData.busses)
        }
    }
    
    func settingsPersistanceDidChangeCity(_ persistance: SettingsPersistance) {
        latestData = nil
        previousData = nil
    }

}

// MARK: - Helpers

private extension MapScene {
    func resetTimeIndycator() {
        if let constraint = timeIndycatorRight {
            // fill animation
            constraint.constant = 0
            UIView.animate(withDuration: 0.25,
                                       delay: 0,
                                       options: .curveEaseOut,
                                       animations:
                {
                    self.view.layoutIfNeeded()
                },
                                       completion:
                { (t:Bool) in
                    // shring animation
                    constraint.constant = t ? self.view.frame.size.width : 0

                    let time: TimeInterval = 18

                    UIView.animate(withDuration: time,
                        delay: 0,
                        options: .curveLinear,
                        animations: {
                            self.view.layoutIfNeeded()
                        },
                        completion: nil)
            })
        }
    }

    func zoomMapOnTheCity() {
        mapView.region = C.Coordinate.WarsawRegion
    }

    func zoomOnUserLocationIfNotShity() {
        if let userLocation = locationManager.location  {
            if userLocation.horizontalAccuracy > 0 && userLocation.verticalAccuracy > 0 {

                let scaleFactor = 0.35
                mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate,
                                                                    C.Coordinate.DefaultSpreadDistance * scaleFactor,
                                                                    C.Coordinate.DefaultSpreadDistance * scaleFactor)
            }
        }
    }

    func styleButton(_ button: UIButton?) {
        button?.layer.shadowColor = UIColor.black.cgColor
        button?.layer.shadowRadius = 2
        button?.layer.shadowOpacity = 0.55
        button?.layer.shadowOffset = CGSize(width: 3, height: 5)

        button?.tintColor = UIColor.eggplant()
    }

    func styleCurrentLocationButton() {
        styleButton(showCurrentLocationButton)
    }

    func styleSettingsButton() {
        styleButton(userSettingsButton)
    }

    func styleRefreshMapDataButton() {
        styleButton(refreshMapDataButton)
    }
}

// MARK: - User Interaction

extension MapScene {

    @IBAction func userDidTapRefreshMapData(_ sender: UIButton) {
        triggerDataRefresh();
    }

    @IBAction func userDidTapShowCurrentLocation(_ sender: UIButton) {
        if let userCor = mapView.userLocation.location {
            mapView.setCenter(userCor.coordinate, animated: true)
        }
    }
}

// MARK: - Data Refreshing 

private extension MapScene {

    var shouldRefreshData: Bool  {
        return true
    }

    func triggerDataRefresh() {
        refreshMapDataButton.isEnabled = false
    }
}

// MARK: - Map View Delegate
extension MapScene: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        var view = mapView.dequeueReusableAnnotationView(withIdentifier: TAnnotationView.ReuseID) as? TAnnotationView

        if view == nil {
            view = TAnnotationView.init(annotation: annotation, reuseIdentifier: TAnnotationView.ReuseID)
        }

        view?.frame.size = C.UI.Map.Dimonsion.AnnotationViewSize
        view?.configure(annotation as! TAnnotation)
        view?.canShowCallout = true

        return view
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let zloto = overlay as! MKPolyline
        let poly = MKPolylineRenderer(polyline: zloto)
        poly.lineWidth = 3
        poly.strokeColor = UIColor.coolGray()

        return poly
    }
}

// MARK: - Updating Map
private extension MapScene {

    func processData(trams: [TData], busses: [TData]) {
        var filteredData: [TData] = {
            let filtered = (persisatance.onlyTrams ? [] : busses) + (persisatance.onlyBusses ? [] : trams)
            
            return filtered
        }()

        // when selected lines are seleted check those to
        if persisatance.selectedLines.count > 0 {
            filteredData = filteredData.filter{
                persisatance.selectedLines.contains($0.lines)
            }
        }

        // now filtered data has only stuff that user is interested in...
        regnerateAnnotations(filteredData)
        updateCopyrightLabelText(filteredData)

        regenerateTramsLocationIndycatiors(filteredData)

        resetTimeIndycator()
    }

    func updateCopyrightLabelText(_ data: [TData]) {
        var copyright = ""

        if let anyData = data.first {
            copyright += anyData.time.replacingOccurrences(of: "T", with: " ")
        }

        copyrightLable.text = copyright
    }
}

// MARK: - Map Annotations
extension MapScene: UserLocationProvider {

    var currentUserLocation: CLLocation? {
        return locationManager.location
    }

    fileprivate func regnerateAnnotations(_ data: [TData]) {
        // remove all annotation views...
        mapView.removeAnnotations(mapView.annotations)

        // map
        let annotations = data.map { (tdata:TData) -> TAnnotation in
            let annotation = TAnnotation(data: tdata)
            annotation.locationProvider = self

            return annotation
        }

        // recreate all annotation views...
        mapView.addAnnotations(annotations)
    }
}

// MARK: - Trams Way Marks
private extension MapScene {
    func regenerateTramsLocationIndycatiors(_ data: [TData]) {

        // remove all
        mapView.overlays.forEach {
            mapView.remove($0)
        }

        // make sure that there is something to show
        guard previousData != nil && latestData != nil else { return }

        // check if user wants to se the data
        guard persisatance.showTramMarks else { return }

        // go over latest and find old posytions
        var previous: [String: CLLocationCoordinate2D] = [:]
        for item in previousData!.all {
            previous[item.keyID] = item.coordinate2D
        }


        var current: [String: CLLocationCoordinate2D] = [:]
        for item in data {
            current[item.keyID] = item.coordinate2D
        }

        // generate set/array whatever with models for the poly lines
        var polyModels:[String: MKPolyline] = [:]

        for (key, currentValue) in current {
            if let prevValue = previous[key] {
                var arr = [currentValue, prevValue]
                let polyLine = MKPolyline.init(coordinates: &arr, count: 2)
                polyModels[key] = polyLine
            }
        }

        // add overlays
        for (_, value) in polyModels {
            mapView.add(value)
        }
    }

    @objc func invalidateTramsPosytionMarkers() {

    }
}

// MARK: - Core Location

extension MapScene: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        showCurrentLocationButton?.isHidden = false

        switch status {

        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .denied:
            showCurrentLocationButton?.isHidden = true

        default:
            break
        }
    }
}

// MARK: - StoreSubscriber

extension MapScene: StoreSubscriber {
    func newState(state: TramsState) {
        print(#function + " \(state)")
    }
}

// MARK: -
