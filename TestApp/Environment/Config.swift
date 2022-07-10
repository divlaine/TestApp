import UIKit

class Config {
    
    static let shared = Config()

    let minCountPassword = 6
    let minCountPhoneCode = 4
    let maxCountPhoneNumber = 11
    let maxCountPhoneCode = 6

    let persistentContainerName = "App"
    
    // MARK: - Your Api Server Url
    private let urlApiDefault = "http://index.php"
    var urlApi: String { get { return "\(urlApiDefault)/api/" } }
}
