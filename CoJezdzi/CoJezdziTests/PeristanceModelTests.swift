import XCTest
@testable import CoJezdzi

class PeristanceModelTests: XCTestCase {
        
    func testShouldSerialiseCorrectly() {
        let inputModels: [PeristanceModel] =
        [
            PeristanceModel.init(city: .Warszawa, selectedLines: [], showTramMarks: false, onlyTrams: false, onlyBusses: false),
            PeristanceModel.init(city: .Warszawa, selectedLines: [], showTramMarks: false, onlyTrams: false, onlyBusses: true),
            PeristanceModel.init(city: .Warszawa, selectedLines: [], showTramMarks: false, onlyTrams: true, onlyBusses: false),
            PeristanceModel.init(city: .Warszawa, selectedLines: [], showTramMarks: true,  onlyTrams: false, onlyBusses: false),
            PeristanceModel.init(city: .Warszawa, selectedLines: ["1"],
                                 showTramMarks: false,  onlyTrams: false, onlyBusses: false),
            PeristanceModel.init(city: .Warszawa, selectedLines: ["1", "2"],
                                 showTramMarks: false,  onlyTrams: false, onlyBusses: false),
            
            PeristanceModel.init(city: .Krakow, selectedLines: [], showTramMarks: false, onlyTrams: false, onlyBusses: false),
            PeristanceModel.init(city: .Krakow, selectedLines: [], showTramMarks: false, onlyTrams: false, onlyBusses: true),
            PeristanceModel.init(city: .Krakow, selectedLines: [], showTramMarks: false, onlyTrams: true, onlyBusses: false),
            PeristanceModel.init(city: .Krakow, selectedLines: [], showTramMarks: true,  onlyTrams: false, onlyBusses: false),
            PeristanceModel.init(city: .Krakow, selectedLines: ["1"],
                                 showTramMarks: false,  onlyTrams: false, onlyBusses: false),
            PeristanceModel.init(city: .Krakow, selectedLines: ["1", "2"],
                                 showTramMarks: false,  onlyTrams: false, onlyBusses: false)
            
        ]
        
        let inputModelAsData: [Data] = inputModels.map { (model) -> Data in
            return NSKeyedArchiver.archivedData(withRootObject: model)
        }
        
        let outModels: [PeristanceModel] = inputModelAsData.map { (modelAsData) -> PeristanceModel in
            return NSKeyedUnarchiver.unarchiveObject(with: modelAsData) as! PeristanceModel
        }
        
        for (inputModel, outModel) in zip(inputModels, outModels) {
            XCTAssertTrue(inputModel == outModel, "Expected model: \(inputModel.description) but got: \(outModel.description)")
        }
    }
    
    func testWhenSelectingTramsOnlyBussesOnlyShoudBeFalse() {
        // Arange
        let testModel = PeristanceModel.buildWith(city: .Warszawa)
        testModel.onlyBusses = true
        
        // Act
        testModel.onlyTrams = true
        
        // Assert
        XCTAssertTrue(testModel.onlyTrams, "Trams shuld be set to true")
        XCTAssertFalse(testModel.onlyBusses, "Busses shoud be set to false")
    }
    
    func testWhenDeselectingTramsOnlyBussesOnlyShoudBeFalse() {
        // Arange
        let testModel = PeristanceModel.buildWith(city: .Warszawa)
        testModel.onlyBusses = true
        
        // Act
        testModel.onlyTrams = false
        
        // Assert
        XCTAssertTrue(testModel.onlyBusses, "Busses shuld be set to true")
        XCTAssertFalse(testModel.onlyTrams, "Trams shoud be set to false")
    }
    
    func testWhenSelectingBussesOnlyTramsOnlyShoudBeFalse() {
        // Arange
        let testModel = PeristanceModel.buildWith(city: .Warszawa)
        testModel.onlyTrams = true
        
        // Act
        testModel.onlyBusses = true
        
        // Assert
        XCTAssertTrue(testModel.onlyBusses, "Busses shuld be set to true")
        XCTAssertFalse(testModel.onlyTrams, "Tramss shoud be set to false")
    }
    
    func testWhenDeselectingBussesOnlyTramsOnlyShoudBeFalse() {
        // Arange
        let testModel = PeristanceModel.buildWith(city: .Warszawa)
        testModel.onlyTrams = true
        
        // Act
        testModel.onlyBusses = false
        
        // Assert
        XCTAssertTrue(testModel.onlyTrams, "Trams shuld be set to true")
        XCTAssertFalse(testModel.onlyBusses, "Busses shoud be set to false")
    }
    
    func testWhenSettingNewCityNewValeShouldBeStored() {
        // Arange
        let testModel = PeristanceModel.buildWith(city: .Warszawa)
        
        // Act
        testModel.city = .Krakow
        
        // Assert
        XCTAssertTrue(testModel.city == .Krakow, "City did not change! Expected: \(AvailableCity.Krakow) but got: \(testModel.city)")
    }
}
