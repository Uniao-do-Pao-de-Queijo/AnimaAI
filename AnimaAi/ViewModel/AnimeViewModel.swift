
import Combine
import UIKit


enum Process: Equatable{
    case ready
    case inProcess
    case finished
    case finishedWithEmptyResult
    case failedWithError(error: Error)
    
    var value: String? {
            return String(describing: self)
         }
    
    static func ==(lhs: Process, rhs: Process) -> Bool {
        return lhs.value == rhs.value
    }
}


class AnimeViewModel {
    private var subscriptions = Set<AnyCancellable>()
    private let utilityQueue = DispatchQueue(label: "utilityQueue", qos: .utility)
    
  
    var loadedPage = 1
    
    var sort = "-user_count"
    

    let animesData = CurrentValueSubject<[Anime], Never>([])
    
    let process = CurrentValueSubject<Process, Never>(.ready)
    
    func fetchAnimesData(page: Int) {
        self.process.send(.inProcess)
        print(page)
        AnimeService.fetchAnimesData(page: page, sort: sort)
            .subscribe(on: utilityQueue)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.process.send(.failedWithError(error: error))
                    break
                default:
                    self.process.send(.finished)
                }
                
                self.subscriptions.removeAll()
            }, receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                self.loadedPage += 1
                
                if page == 1 {
                    self.animesData.send(receivedValue.data)
                } else {
                    let oldValue = self.animesData.value
                    let newValue = oldValue + receivedValue.data
                    self.animesData.send(newValue)
                }
            }
                  
            )
            .store(in: &subscriptions)
    }
    
    init() {
        self.fetchAnimesData(page: 1)
    }
    
    
    
}
