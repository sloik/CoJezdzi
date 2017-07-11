import XCTest
@testable import CoJezdzi

typealias PersistnaceBlock = (_ persistance: SettingsPersistance) -> ()

class SettingsPersistanceTests: XCTestCase {
    
    var persistanceStore: SettingsPersistanceStore?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {


        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaults() {
        // Arange
        let testData: [(actions: PersistnaceBlock, asserts: PersistnaceBlock)] =
        [
            ({ persistance in },
             { persistance in self.assertCity(testId: "No Action",
                                                   persistance: persistance, expected: .Warszawa) }),
            
            ({ persistance in persistance.seletedCity = .Krakow },
             { persistance in self.assertCity(testId: "Change City Once",
                                                   persistance: persistance, expected: .Krakow) }),
            
            ({ persistance in
                persistance.seletedCity = .Krakow
                persistance.seletedCity = .Warszawa
            },
             { persistance in self.assertCity(testId: "Change Kra->Waw",
                                                   persistance: persistance, expected: .Warszawa) }),
            
            ({ persistance in
                persistance.seletedCity = .Krakow; persistance.seletedCity = .Warszawa; persistance.seletedCity = .Krakow
            },
             { persistance in self.assertCity(testId: "Change Kra->Waw->Kra",
                                              persistance: persistance, expected: .Krakow) })
        ]
        
        
        testData.forEach { (action, assert) in
            let systemUnderTest = freshPersistanceInstance()

            // Act
            action(systemUnderTest)
            
            // Assert
            assert(systemUnderTest)
        }
    }
    
    func testDefaultsRandomPermutation() {
        let systemUnderTest = freshPersistanceInstance()
        
        var city: AvailableCity = .Warszawa
        
        for _ in 0...100 {
            city = randomCity()
            systemUnderTest.seletedCity = city
        }
        
        assertCity(persistance: systemUnderTest, expected: city)
    }
    
    func testOnlyTrams() {
        // Arange
        let systemUnderTest = freshPersistanceInstance()
        
        // Act
        systemUnderTest.seletedCity = .Krakow
        systemUnderTest.onlyTrams = true
        
        // Assert
        XCTAssertTrue(systemUnderTest.onlyTrams, "Only trams filter should be on")
        XCTAssertTrue(systemUnderTest.seletedCity == .Krakow, "City shoud be Krakow but got: \(systemUnderTest.seletedCity)")
    }
    
    func testOnlyBusses() {
        // Arange
        let systemUnderTest = freshPersistanceInstance()
        
        // Act
        systemUnderTest.seletedCity = .Krakow
        systemUnderTest.onlyBusses = true
        
        // Assert
        XCTAssertTrue(systemUnderTest.onlyBusses, "Only busses filter should be on")
        XCTAssertTrue(systemUnderTest.seletedCity == .Krakow, "City shoud be Krakow but got: \(systemUnderTest.seletedCity)")
    }
    
    func testOnlyBussesInKrakow() {
        // Arange
        let systemUnderTest = freshPersistanceInstance()
        
        // Act
        systemUnderTest.seletedCity = .Krakow
        systemUnderTest.onlyBusses = true
        systemUnderTest.seletedCity = .Warszawa
        systemUnderTest.onlyTrams = true
        systemUnderTest.seletedCity = .Krakow
        
        // Assert
        XCTAssertTrue(systemUnderTest.onlyBusses, "Only busses filter should be on")
        XCTAssertFalse(systemUnderTest.onlyTrams, "Only trams filter should be off")
        
        XCTAssertTrue(systemUnderTest.seletedCity == .Krakow, "City shoud be Krakow but got: \(systemUnderTest.seletedCity)")
    }
    
    func testOnlyBussesInKrakowAndWarszawaShouldBeOn() {
        // Arange
        let systemUnderTest = freshPersistanceInstance()
        
        // Act
        systemUnderTest.seletedCity = .Krakow
        systemUnderTest.onlyBusses = true
        systemUnderTest.seletedCity = .Warszawa
        systemUnderTest.onlyBusses = true
        
        systemUnderTest.seletedCity = .Krakow
        let krakowBussesOnly = systemUnderTest.onlyBusses
        
        systemUnderTest.seletedCity = .Warszawa
        let warszawaBussesOnly = systemUnderTest.onlyBusses
        
        // Assert
        XCTAssertTrue(krakowBussesOnly,     "Krakow busses only filter shoud be on")
        XCTAssertTrue(warszawaBussesOnly,   "Warszawa busses only filter shoud be on")
    }
    
    func testPermutateBussesOnlyFilterInRandomCities() {

        // Arrange
        var testResult = TestState()
        let systemUnderTest = freshPersistanceInstance()
        
        // Act
        for _ in 0...200 {
            let city = randomCity()
            let filterOn = randomFilterOnOff()
            
            systemUnderTest.seletedCity = city
            systemUnderTest.onlyBusses = filterOn
            
            testResult.update(city: city, filterOn: filterOn)
        }
        
        // Assert
        assertTestResult(persistance: systemUnderTest, withReult: testResult)
    }
    
    func testWhenSettingMiltipleTimesTheSameCityDelegateShoudFireOnlyOnce() {
        
        // Arrange
        let systemUnderTest = freshPersistanceInstance()
        let eventDelegate   = EventDelegateStub()
        
        systemUnderTest.eventDelegate = eventDelegate
        
        // Act
        for _ in 0...100 {
            systemUnderTest.seletedCity = .Warszawa
        }
        
        // Assert
        XCTAssertTrue(eventDelegate.cityChange == 0, "City change delegate method should not be fired once! Did fire: \(eventDelegate.cityChange)")
        XCTAssertTrue(eventDelegate.saveCount == 0, "Persiste change should no be caled! Did fire: \(eventDelegate.saveCount)")
    }
    
    func testWhenChangingCityTheDelegateMethodsShouldBeFired() {
        // Arrange
        let systemUnderTest = freshPersistanceInstance()
        let eventDelegate   = EventDelegateStub()
        
        systemUnderTest.eventDelegate = eventDelegate
        
        // Act
        systemUnderTest.seletedCity = .Krakow
        
        // Assert
        XCTAssertTrue(eventDelegate.cityChange == 1, "City change delegate method should fire onece! Did fire: \(eventDelegate.cityChange)")
        XCTAssertTrue(eventDelegate.saveCount > 0,   "Persiste change should fire! Did fire: \(eventDelegate.saveCount)")
    }
}

typealias SelectedLinesTests = SettingsPersistanceTests
extension SelectedLinesTests {
    func testShoudStoreSelectedLinesPerCity() {
        // Arrange
        let systemUnderTest = freshPersistanceInstance()
        
        // Act
        let selectedLines = ["10", "11"]
        systemUnderTest.selectedLines = selectedLines
        systemUnderTest.seletedCity = .Krakow
        systemUnderTest.selectedLines = selectedLines
        
        // Assert
        assertLines(in: systemUnderTest, for: .Warszawa, expectedLines: selectedLines)
        assertLines(in: systemUnderTest, for: .Krakow, expectedLines: selectedLines)
    }
}

typealias ShowTramMarksTests = SettingsPersistanceTests
extension ShowTramMarksTests {
    func testShoudStoreShowTramMarksPerCity() {
        // Arrange
        let systemUnderTest = freshPersistanceInstance()
        
        // Act
        systemUnderTest.showTramMarks = false
        systemUnderTest.seletedCity = .Krakow
        systemUnderTest.showTramMarks = false
        
        // Assert
        assertShowTramMarks(in: systemUnderTest, for: .Warszawa, expectedState: false)
        assertShowTramMarks(in: systemUnderTest, for: .Krakow, expectedState: false)
    }
}


typealias MissingRegistratedDefaultsTests = SettingsPersistanceTests
extension MissingRegistratedDefaultsTests {
    func testWhenStoreIsMissingDataForModelInvalidInitShouldReturnDefaultModel() {
        
        // Arrange
        let store = StubStoreNoRegister()
        let systemUnderTest = SettingsPersistance.init(defaults: store)
        
        // Act
        
        // Assert
        assertCity(persistance: systemUnderTest, expected: .Warszawa)
    }
    
    func testWhenStoreHasInvalidDataForModelInitShouldReturnDefaultModel() {
        
        // Arrange
        let store = StubStoreNoRegister()
        
        let dummyData = NSKeyedArchiver.archivedData(withRootObject: "dummy object")
        store.set(dummyData, forKey: "ModelKey") // SettingsConstants.ModelKey
        
        let systemUnderTest = SettingsPersistance.init(defaults: store)
        
        // Act
        
        // Assert
        assertCity(persistance: systemUnderTest, expected: .Warszawa)
    }
}

private extension SettingsPersistanceTests {
    class EventDelegateStub: SettingsEvent {
        
        var cityChange = 0
        var saveCount  = 0
        
        func settingsPersistanceDidChangeCity(_ persistance: SettingsPersistance) {
            cityChange += 1
        }
        
        func settingsPersistanceDidPersist(_ persistance: SettingsPersistance) {
            saveCount += 1
        }
        
    }
    
    class StubStoreNoRegister: SettingsPersistanceStore {
        var backingStore: [String:Any] = [:]
        
        func set(_ value: Any?, forKey defaultName: String) {
            if let value = value {
                backingStore[defaultName] = value
            } else {
                backingStore.removeValue(forKey: defaultName)
            }
        }
        
        func data(forKey defaultName: String) -> Data? {
            return backingStore[defaultName] as? Data
        }
        
        func synchronize() -> Bool {
            return true
        }
        
        func registerDefaults(defaults: [String : Any]) {
            
        }
    }
    
    class StubStore: StubStoreNoRegister {
        
        override func registerDefaults(defaults: [String : Any]) {
            for (key, value) in defaults {
                if backingStore[key] == nil {
                    backingStore[key] = value
                }
            }
        }
    }
    
    struct TestState {
        var results: [AvailableCity: Bool] = [:]
        
        mutating func update(city: AvailableCity, filterOn: Bool) {
            results[city] = filterOn
        }
    }
}

private extension SettingsPersistanceTests {
    
    func freshPersistanceInstance() -> SettingsPersistance {
        let store = StubStore.init()
        
        return SettingsPersistance.init(defaults: store)
    }
    
    func randomCity() -> AvailableCity {
        let random = Int(arc4random_uniform(UInt32(AvailableCity.allCases.count)))
        let city = AvailableCity.allCases[random]
        
        return city
    }
    
    func randomFilterOnOff() -> Bool {
        return Int(arc4random()) % 2 == 0
    }
    
    func assertCity(testId: String = "", persistance: SettingsPersistance, expected: AvailableCity,
                         file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(persistance.seletedCity == expected,  "\(testId) >> Defualt city should be \(expected) but got: \(persistance.seletedCity)", file: file, line: line)
        XCTAssertTrue(persistance.selectedLines == [],      "\(testId) >> Defualt selectedLines should be \([] as [String]) but got: \(persistance.selectedLines)", file: file, line: line)
        XCTAssertTrue(persistance.showTramMarks,            "\(testId) >> Previous posytion indycaators shoud be set to true", file: file, line: line)
        XCTAssertFalse(persistance.onlyTrams,               "\(testId) >> Only Trams filter shoud be false", file: file, line: line)
        XCTAssertFalse(persistance.onlyBusses,              "\(testId) >> Only Busses filter shoud be false", file: file, line: line)
    }
    
    func assertTestResult(testId: String = "", persistance: SettingsPersistance, withReult: SettingsPersistanceTests.TestState,
                          file: StaticString = #file, line: UInt = #line) {
        
        for (city, filterState) in withReult.results {
            persistance.seletedCity = city
            
            XCTAssertTrue(persistance.onlyBusses == filterState, "\(testId) >> In city: \(city) busses only should be \(filterState) but got: \(persistance.onlyBusses)", file: file, line: line)
        }
        
    }
    
    func assertLines(testId: String = "", in persistance: SettingsPersistance, for city: AvailableCity, expectedLines: [String],
                            file: StaticString = #file, line: UInt = #line) {
        
        persistance.seletedCity = city
        let storedLines = persistance.selectedLines
        
        let expected = Set(expectedLines)
        let stored   = Set(storedLines)
        
        XCTAssertEqual(expected, stored, "\(testId) >> Stored lines are different! Expected: \(expectedLines), got: \(storedLines)", file: file, line: line)
    }
    
    func assertShowTramMarks(testId: String = "",in persistance: SettingsPersistance, for city: AvailableCity, expectedState: Bool,
                     file: StaticString = #file, line: UInt = #line) {
        
        persistance.seletedCity = city

        XCTAssertTrue(persistance.showTramMarks == expectedState, "\(testId) >> Invalid state for show tram marks! Expected: \(expectedState), got: \(persistance.showTramMarks)", file: file, line: line)
    }
}
