import Foundation

enum AvailableCity: String {
    case Warszawa = "Warszawa"
    case Krakow   = "Kraków"
    
    static var allCases: [AvailableCity] {
        return [.Warszawa, .Krakow]
    }
}

internal func ==(lhs: PeristanceModel, rhs: PeristanceModel) -> Bool {
    
    let left  = NSKeyedArchiver.archivedData(withRootObject: lhs)
    let right = NSKeyedArchiver.archivedData(withRootObject: rhs)
    
    return left == right
}

class PeristanceModel: NSObject, NSCoding {
    var city: AvailableCity {
        set {
            rawCity = newValue.rawValue
        }
        get {
            return AvailableCity(rawValue: self.rawCity)!
        }
    }
    
    @objc private var rawCity: String
    @objc var selectedLines:  [String]
    @objc var showTramMarks:  Bool
    
    @objc var onlyTrams: Bool {
        didSet {
            if onlyTrams {
                self.onlyBusses = false
            }
        }
    }
    
    @objc var onlyBusses: Bool {
        didSet {
            if onlyBusses {
                self.onlyTrams = false
            }
        }
    }
    
    init(city: AvailableCity, selectedLines: [String], showTramMarks: Bool, onlyTrams: Bool, onlyBusses: Bool) {
        self.rawCity = city.rawValue
        self.selectedLines = selectedLines
        self.showTramMarks = showTramMarks
        self.onlyTrams = onlyTrams
        self.onlyBusses = onlyBusses
    }
        
    public required init?(coder aDecoder: NSCoder) {
        rawCity = aDecoder.decodeObject(forKey: #keyPath(rawCity)) as! String
        selectedLines = aDecoder.decodeObject(forKey: #keyPath(selectedLines)) as! [String]
        showTramMarks = aDecoder.decodeBool(forKey: #keyPath(showTramMarks))
        onlyTrams = aDecoder.decodeBool(forKey: #keyPath(onlyTrams))
        onlyBusses = aDecoder.decodeBool(forKey: #keyPath(onlyBusses))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city.rawValue, forKey: #keyPath(rawCity))
        aCoder.encode(selectedLines, forKey: #keyPath(selectedLines))
        aCoder.encode(showTramMarks, forKey: #keyPath(showTramMarks))
        aCoder.encode(onlyTrams, forKey: #keyPath(onlyTrams))
        aCoder.encode(onlyBusses, forKey: #keyPath(onlyBusses))
    }
    
    static func buildWith(city: AvailableCity) -> PeristanceModel {
        return PeristanceModel(city: city, selectedLines: [], showTramMarks: true, onlyTrams: false, onlyBusses: false)
    }
}

extension PeristanceModel {
    override var description: String {
        return "\(city) selected: \(String(describing: selectedLines)) tramMarks: \(showTramMarks) onlyTrams: \(onlyTrams) onlyBusses: \(onlyBusses)"
    }
}

