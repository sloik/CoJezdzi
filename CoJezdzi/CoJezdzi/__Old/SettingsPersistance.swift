import Foundation

fileprivate struct SettingsConstants {
    static let ModelKey = "ModelKey"
}

protocol SettingsPersistanceStore {
    func registerDefaults(defaults: [String:Any])
    
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)
    
    @discardableResult func synchronize() -> Bool
}

extension UserDefaults: SettingsPersistanceStore {
    func registerDefaults(defaults: [String : Any]) {
        self.register(defaults: defaults)
    }
}

class SettingsPersistance {
    private var defaults: SettingsPersistanceStore
    private var currentModel: PeristanceModel
    
    init(defaults: SettingsPersistanceStore = UserDefaults.standard) {
        
        func registerDefaults() {
            let warsawModel = PeristanceModel.buildWith(city: .Warszawa)
            let warsawModelAsData = NSKeyedArchiver.archivedData(withRootObject: warsawModel)
            defaults.registerDefaults(defaults: [SettingsConstants.ModelKey: warsawModelAsData])
            
            AvailableCity.allCases.forEach { (city) in
                let model = PeristanceModel.buildWith(city: city)
                let modelAsData = NSKeyedArchiver.archivedData(withRootObject: model)
                defaults.registerDefaults(defaults: [city.rawValue: modelAsData])
            }
        }
        
        self.defaults = defaults
        
        registerDefaults()
        
        currentModel = {
            let defaultModelProducer: ()-> PeristanceModel = {
                let defaultModel = PeristanceModel.buildWith(city: .Warszawa)
                return defaultModel
            }
            
            guard let data = defaults.data(forKey: SettingsConstants.ModelKey) else {
                return defaultModelProducer()
            }

            if let decodedModel = NSKeyedUnarchiver.unarchiveObject(with: data) as? PeristanceModel {
                return decodedModel
            }
            
            return defaultModelProducer()
        }()
    }
    
    var seletedCity: AvailableCity {
        set {
            guard currentModel.city != newValue else {
                return
            }
            
            // save current
            let curentModelAsData = NSKeyedArchiver.archivedData(withRootObject: currentModel)
            defaults.set(curentModelAsData, forKey: currentModel.city.rawValue)
            
            // get the desired one
            let model = self.model(forCity: newValue)
            
            // update current to the desired one
            currentModel = model 
            
            synchronize()
        }
        get {
            return currentModel.city
        }
    }

    var selectedLines: [String] {
        set { currentModel.selectedLines = newValue; synchronize() }
        get { return currentModel.selectedLines }
    }

    var showTramMarks: Bool {
        set { currentModel.showTramMarks = newValue;  synchronize()}
        get { return currentModel.showTramMarks }
    }
    
    var onlyTrams: Bool {
        set { currentModel.onlyTrams = newValue;  synchronize()}
        get { return currentModel.onlyTrams }
    }
    
    var onlyBusses: Bool {
        set { currentModel.onlyBusses = newValue; synchronize() }
        
        get { return currentModel.onlyBusses }
    }

    private func synchronize() {
        saveCurrentModel()
    }
    
    private func saveCurrentModel() {
        let data = NSKeyedArchiver.archivedData(withRootObject: currentModel)
        defaults.set(data, forKey: currentModel.city.rawValue)
        defaults.set(data, forKey: SettingsConstants.ModelKey)

        defaults.synchronize()
    }
    
    private func model(forCity: AvailableCity) -> PeristanceModel {
        let data = defaults.data(forKey: forCity.rawValue)!
        
        if let decodedModel = NSKeyedUnarchiver.unarchiveObject(with: data) as? PeristanceModel {
            return decodedModel
        }
        
        return PeristanceModel.buildWith(city: forCity)
    }
}
