import Foundation

protocol UserDataService {
    func getImagePath() -> String
    func saveImagePath(path: String)
}
