import XCTest
@testable import CoJezdzi

class DataPullerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShoudHaveDateFormatter() {
        // Arrange
        let systemUnderTest = freshDealer()
        // Act
        
        // Assert
        XCTAssertNotNil(systemUnderTest.currentDateFormatter, "Shoud have date formatter")
    }
    
    func testShoudProvideRefresRate() {
        // Arrange
        let systemUnderTest = freshDealer()
        
        // Act
        
        // Assert
        XCTAssertEqualWithAccuracy(systemUnderTest.refresRate, TimeInterval(13), accuracy: 0.1, "Expected to have 13s refresh rate! But got: \(systemUnderTest.refresRate)")
    }
    
    func testShoudProvideDefaultRefresRateWhenApiDealerIsNil(){
        // Arrange
        let systemUnderTest = freshDealer()
        
        // Act
        systemUnderTest.apiDealer = nil
        
        // Assert
        XCTAssertEqualWithAccuracy(systemUnderTest.refresRate, TimeInterval(30), accuracy: 0.1, "Expected to have 30s refresh rate! But got: \(systemUnderTest.refresRate)")
    }
    
    func testStartPulllingFiresCompletionBlock() {
        // Arrange
        let blockShouldFire = self.expectation(description: "block should fire!")
        let systemUnderTest = freshDealer(trams: [testTData()]) { _, _ in
            blockShouldFire.fulfill()
        }
        
        // Act
        systemUnderTest.startPullingTData()
        
        // Assert
        self.waitForExpectations(timeout: 10.0) { (error) in

            if let error = error {
                XCTFail("Some error: \(error)")
            }
        }
    }
    
    func testupdateWithLastStateShouldGiveBackLastFetchData() {
        // Arrange
        let blockShouldFire = self.expectation(description: "block should fire!")
        let testData = [testTData(id:"1", lat: 1), testTData(id:"2", lat: 2)]
        let systemUnderTest = freshDealer(trams: testData) { pulledTrams, _ in
            
            XCTAssertEqual(pulledTrams, testData)
            blockShouldFire.fulfill()
        }
        
        // Act
        systemUnderTest.updateWithLastState()
        
        // Assert
        self.waitForExpectations(timeout: 2.0) { (error) in
            
            if let error = error {
                XCTFail("Some error: \(error)")
            }
        }
    }
}

private typealias CustomAssertions = DataPullerTests
extension CustomAssertions {
    
}

private typealias HelperMethods = DataPullerTests
extension HelperMethods {
    
    struct StubDataProvider: DataPullerDataProvider {
        let trams: [TData]
        let busses: [TData]
        
        var refreshRate: TimeInterval = 13
        var dateFormatter: DateFormatter = {
            let formatter = Foundation.DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            return formatter
        }()
        
        var apiBaseUrl: String {
            return "Fake.Api.Base.Url"
        }
        
        func getLastFetchedData(_ completion: @escaping FullDataPullingCompletion) {
            completion(trams, busses)
        }
        
        func getTramsAndBusData(_ completion: @escaping FullDataPullingCompletion) {
            completion(trams, busses)
        }
        
        init(trams: [TData], busses: [TData]){
            self.trams = trams
            self.busses = busses
        }
    }
    
    func freshDealer(trams: [TData] = [], busses: [TData] = [], completion: FullDataPullingCompletion? = nil) -> DataPuller {
        let dataProvider = StubDataProvider(trams: trams, busses: busses)
        
        let puller = DataPuller(apiDealer: dataProvider, completion: completion ?? {_,_ in })
        
        return puller
    }
    
    func testTData(id: String = "12345678", lat: Int = 180365650 ) -> TData {
        let vehicle = KrakowVehicle(category: "tram", color: "", heading: 1, id: id, isDeleted: nil, latitude: lat, longitude: 72045296, name: "35 Wesoly Bus", path: nil, tripId: "")
        let trueVehicle = TrueVehicle(vehicle: vehicle)
        let dataProvider = StubDataProvider(trams: [], busses: [])
        
        let data = TData(vehicle: trueVehicle, date: dataProvider.dateFormatter.string(from: Date()) )
        
        return data
    }
}
