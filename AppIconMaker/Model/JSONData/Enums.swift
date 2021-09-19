import Foundation

enum IconIdiom: String, Codable {
    case mac = "mac"
    case iphone = "iphone"
    case ipad = "ipad"
    case iosMarketing = "ios-marketing"
}

enum IconScale: String, Codable {
    case the1X = "1x"
    case the2X = "2x"
    case the3X = "3x"
    
    func toInt() -> Int {
        switch self {
        case .the1X:
            return 1
        case .the2X:
            return 2
        case .the3X:
            return 3
        default:
            return 1
        }
    }
}
