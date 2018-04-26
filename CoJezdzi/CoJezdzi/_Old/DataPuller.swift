import Foundation

protocol Copyrightable {
    var copyRightInfo: String? { get }
}

class DataPuller: NSObject {

    var apiDealer: DataPullerDataProvider? = nil
    var curentApiBaseUrl: String {
        return apiDealer!.apiBaseUrl
    }
                      var defaultRefresRate    : TimeInterval = 30
    fileprivate       var timerOffsetToNextPool: TimeInterval = 0
    fileprivate final var timer   : Timer?
    fileprivate final var success : Bool = true


    var timeToNextPull: TimeInterval {

        guard let timer = timer else { return 0 }

        // will be negative if timer fire date is eariler than "now"
        let nowDate = timer.fireDate.timeIntervalSinceNow

        // no sense to return negative time...
        if nowDate < 0 { return 0 }

        return nowDate
    }
    
    var currentDateFormatter: DateFormatter {
        return apiDealer!.dateFormatter
    }
    
    var refresRate: TimeInterval {
        return apiDealer?.refreshRate ?? defaultRefresRate 
    }

    final let completion: FullDataPullingCompletion

    init(apiDealer: DataPullerDataProvider, completion: @escaping FullDataPullingCompletion) {
        self.completion = completion
        self.apiDealer = apiDealer
    }

    func startPullingTData() {
        if timer == nil {
            timer = createTimer(apiDealer?.refreshRate ?? defaultRefresRate)
        }

        timer!.fire()
    }
    
    func updateWithLastState() {
        guard let apiDealer = apiDealer else {
            return
        }
        
        apiDealer.getLastFetchedData { (trams, busses) in
            DispatchQueue.main.async { [unowned self] in
                self.completion(trams, busses)
            }
        }
    }

    func refreshData() {
        updateWithLastState()
        startPullingTData()
    }

    @objc fileprivate func pullTDataData() {
        
        guard let apiDealer = apiDealer else {
            DispatchQueue.main.async {
                self.scheduleNextUpdate([])
            }
            return
        }
        
        apiDealer.getTramsAndBusData { (trams, busses) in
            DispatchQueue.main.async { [unowned self] in
                let allData = trams + busses
                self.scheduleNextUpdate(allData)
                
                if self.success {
                    self.completion(trams, busses)
                }
            }
        }
    }

    fileprivate func scheduleNextUpdate(_ data: [TData]) {

        // should be already invalidated but just to be extra shure...
        timer?.invalidate()

        timerOffsetToNextPool = calculateTimeOffset(data)

        timer = createTimer(timerOffsetToNextPool)
    }

    fileprivate func createTimer(_ timeOffset: TimeInterval) -> Timer {
        return Timer.scheduledTimer(timeInterval: timeOffset,
            target: self,
            selector: #selector(DataPuller.pullTDataData),
            userInfo: nil,
            repeats: false)
    }

    fileprivate func calculateTimeOffset(_ data: [TData]) -> TimeInterval {

        let hasData = data.count > 0

        if hasData == false && success == true {
            success = false
            return 1
        }

        let timeToStartOffset: TimeInterval = apiDealer?.refreshRate ?? defaultRefresRate

        return timeToStartOffset
    }
}

extension DataPuller: Copyrightable {
    var copyRightInfo: String? {
        if let dealer = apiDealer as? Copyrightable {
            return dealer.copyRightInfo
        }
        
        return nil
    }
}
