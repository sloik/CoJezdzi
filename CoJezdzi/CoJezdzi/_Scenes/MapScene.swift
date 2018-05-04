import MapKit
import UIKit
import ReSwift

struct PayloadData {
    let busses: [WarsawVehicleDto]
    let trams: [WarsawVehicleDto]
    
    var all: [WarsawVehicleDto] {
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

class MapScene: UIViewController {

    // MARK: - UI
    @IBOutlet weak var copyrightLable: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var showCurrentLocationButton: UIButton? {
        didSet {
            styleButton(showCurrentLocationButton)
        }
    }
    
    @IBOutlet weak var userSettingsButton: UIButton! {
        didSet {
            styleButton(userSettingsButton)
        }
    }
    
    @IBOutlet weak var refreshMapDataButton: UIButton! {
        didSet {
            styleButton(refreshMapDataButton)
        }
    }

    @IBOutlet weak var timeIndycatorRight: NSLayoutConstraint?
    @IBOutlet weak var timeIndycatorView: UIView?

    // MARK: -
    let locationManager: CLLocationManager

    fileprivate var processDataDate = Date()

    required init?(coder aDecoder: NSCoder) {
        locationManager = CLLocationManager.init()
        
        super.init(coder: aDecoder)
        
        locationManager.delegate = self
    }

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()

        mapView.delegate = self as MKMapViewDelegate

        zoomMapOnTheCity()
        zoomOnUserLocationIfNotShity()

        timeIndycatorView?.backgroundColor = UIColor.grape()
        
        store.dispatch(FetchTramsAction.fetch)
        
        Timer.scheduledTimer(withTimeInterval: WarsawApiConstants.RefreshRate,
                             repeats: true) { _ in
                                store.dispatch(FetchTramsAction.fetch)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self)
        
        store.dispatch(RoutingAction(destination: .map))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
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
    func triggerDataRefresh() {
        store.dispatch(FetchTramsAction.fetch)
    }
}


// MARK: - Updating Map
private extension MapScene {

    func processData(_ state: MapSceneState) {
//        var filteredData: [WarsawVehicleDto] = {
////            let filtered = (persisatance.onlyTrams ? [] : busses) + (persisatance.onlyBusses ? [] : trams)
////
////            return filtered
//            return []
//        }()
//
//        // when selected lines are seleted check those to
//        if persisatance.selectedLines.count > 0 {
//            filteredData = filteredData.filter{
//                persisatance.selectedLines.contains($0.lines)
//            }
//        }

        // now filtered data has only stuff that user is interested in...
        regnerateAnnotations(state)
        updateCopyrightLabelText(state)

        regenerateTramsLocationIndycatiors(state)

        resetTimeIndycator()
    }

    func updateCopyrightLabelText(_ state: MapSceneState) {
        var copyright = ""

        if let anyData = state.currentTrams.data.first {
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

    fileprivate func regnerateAnnotations(_ state: MapSceneState) {
        // remove all annotation views...
        mapView.removeAnnotations(mapView.annotations)

        // map
        let annotations = state.currentTrams.data.map { (tdata:WarsawVehicleDto) -> TAnnotation in
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
    func regenerateTramsLocationIndycatiors(_ state: MapSceneState) {
        
        guard state.currentTrams.data.isEmpty == false && state.currentTrams.previousData.isEmpty == false else {
            return
        }
        
        // remove all
        mapView.removeOverlays(mapView.overlays)

//        // check if user wants to se the data
//        guard persisatance.showTramMarks else { return }
        
        let reduceBlock = { (acc: StringCoordinateDic, vehicle: WarsawVehicleDto) -> StringCoordinateDic in
            var ret = acc
            ret[vehicle.keyID] = vehicle.coordinate2D
            
            return ret
        }
        
        // go over latest and find old posytions
        let previous = state.currentTrams.previousData.reduce(StringCoordinateDic(), reduceBlock)
        let current  = state.currentTrams.data.reduce(StringCoordinateDic(), reduceBlock)

        // add overlays
        PolylineMaker.generetePolylines(previousPosytions: previous, currentPosytions: current).values.forEach{ mapView.add($0) }
    }
}

// MARK: - StoreSubscriber

extension MapScene: StoreSubscriber {
    func newState(state: AppState) {
        processData(state.mapSceneState)
    }
}

// MARK: -
