
import MapKit

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
