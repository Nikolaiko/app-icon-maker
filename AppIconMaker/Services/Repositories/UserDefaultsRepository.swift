import Foundation

struct UserDefaultsRepository: UserDataService {
    private static let imagePathKey = "image_path_key"
    private static let appFolder = "AppIconMaker"
    
    private var defaultImagePath: URL
    private let userDefaults = UserDefaults.init()
    
    
    init() {
        let paths = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        
        defaultImagePath = paths.first!
        defaultImagePath.appendPathComponent(
            UserDefaultsRepository.appFolder, isDirectory: true)
    }
    
    func getImagePath() -> String {
        userDefaults.string(
            forKey: UserDefaultsRepository.imagePathKey) ?? defaultImagePath.relativeString
    }
    
    func saveImagePath(path: String) {
        userDefaults.setValue(path, forKey: UserDefaultsRepository.imagePathKey)
    }
}
