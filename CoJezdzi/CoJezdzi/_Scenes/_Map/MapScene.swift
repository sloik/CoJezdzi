
import MapKit
import UIKit

import ReSwift

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
        
        triggerDataRefresh()

        Timer.scheduledTimer(withTimeInterval: WarsawApiConstants.RefreshRate,
                             repeats: true) { _ in
                                self.triggerDataRefresh()
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

                    let time: TimeInterval = WarsawApiConstants.RefreshRate

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
    
    @IBAction func userDidTapSettingsButton() {
        store.dispatch(RoutingAction(destination: .settings))
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
        store.dispatch(FetchBussesAction.fetch)
    }
}


// MARK: - Updating Map
private extension MapScene {

    func processData(_ state: AppState) {

        // now filtered data has only stuff that user is interested in...
        regnerateAnnotations(state)
        updateCopyrightLabelText(state.mapState)

        regenerateTramsLocationIndycatiors(state)

        resetTimeIndycator()
    }

    func updateCopyrightLabelText(_ state: MapState) {
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

    fileprivate func regnerateAnnotations(_ state: AppState) {
        // remove all annotation views...
        mapView.removeAnnotations(mapView.annotations)

        // map
        let annotations = state.mapState
            .allCurrent
            .filter { filterByLine(state: state, dto: $0) }
            .filter { filterByType(state: state, dto: $0) }
            .map { (tdata:WarsawVehicleDto) -> TAnnotation in
            let annotation = TAnnotation(data: tdata)
            annotation.locationProvider = self

            return annotation
        }

        // recreate all annotation views...
        mapView.addAnnotations(annotations)
    }
}

// MARK: - Filters

private extension MapScene {
    func filterByLine(state: AppState, dto: WarsawVehicleDto) -> Bool {
        let selectedLines = state.settingsState.selectedLines.lines
        return selectedLines.isEmpty ? true
                                     : selectedLines.contains(LineInfo(name: dto.lines))
    }
    
    func filterByType(state: AppState, dto: WarsawVehicleDto) -> Bool {
        let types = state.settingsState.switches
        let switches = (types.tramOnly.isOn, types.busOnly.isOn)
        
        switch switches {
        case (true, _): return dto.type == .tram
        case (_, true): return dto.type == .bus
        case (_, _)   : return true
        }
    }
}

// MARK: - Trams Way Marks
private extension MapScene {
    func regenerateTramsLocationIndycatiors(_ state: AppState) {
        
        guard state.mapState.currentTrams.data.isEmpty == false && state.mapState.currentTrams.previousData.isEmpty == false else {
            return
        }
        
        // remove all
        mapView.removeOverlays(mapView.overlays)

        // check if user wants to se the data
        guard state.settingsState.switches.previousLocations.isOn else { return }
        
        let reduceBlock = { (acc: StringCoordinateDic, vehicle: WarsawVehicleDto) -> StringCoordinateDic in
            var ret = acc
            ret[vehicle.keyID] = vehicle.coordinate2D
            
            return ret
        }
        
        // go over latest and find old posytions
        let previous = state.mapState
            .allPrevious
            .filter { filterByLine(state: state, dto: $0) }
            .filter { filterByType(state: state, dto: $0) }
            .reduce(StringCoordinateDic(), reduceBlock)
        
        let current  = state.mapState
            .allCurrent
            .reduce(StringCoordinateDic(), reduceBlock)
        
        // add overlays
        PolylineMaker.generetePolylines(previousPosytions: previous, currentPosytions: current).values.forEach{ mapView.add($0) }
    }
}

// MARK: - StoreSubscriber

extension MapScene: StoreSubscriber {
    func newState(state: AppState) {
        processData(state)
    }
}

// MARK: -
