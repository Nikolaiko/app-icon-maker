import SwiftUI
import Combine
import Resolver

class MainViewModel: ObservableObject {
    
    @Injected private var imageResizer: ImageResizer
    @Injected private var parser: XCAssetsParser
    
    private var destinationUrl: URL?
    private var projectDestinationUrl: URL?
    
    @Published private(set) var imageFileUrl: URL?    
    @Published private(set) var imageFileSelected = false
    
    @Published var imageFileName: String = ""
    @Published var destinationPath: String = ""
    @Published var projectDestinationPath: String = ""
    
    func updateImageUrl(imageUrl: URL) {
        imageFileUrl = imageUrl
        imageFileSelected = true
        
        let filename: String = imageUrl.pathComponents.last ?? ""
        imageFileName = String(filename.split(separator: ".").first ?? "")
    }
    
    func updateProjectDestinationURL(newUrl: URL) {
        projectDestinationUrl = newUrl
        projectDestinationPath = projectDestinationUrl?.path ?? ""
    }
    
    func updateDestinationUrl(newUrl: URL) {
        destinationUrl = newUrl
        destinationPath = destinationUrl?.path ?? ""
    }
    
    func generateIcons() {
        imageResizer.resizeImageToIcons(
            sourceUrl: imageFileUrl!,
            sourceFileName: imageFileName,
            destinationUrl: destinationUrl!
        )
    }
    
    func importIconsToProject() {
        let subPath = projectDestinationUrl!
            .appendingPathComponent("AppIcon.appiconset")
        
        let jsonFilePath = subPath
            .appendingPathComponent("Contents.json")
        
        if let iconsData = parser.parse(destination: jsonFilePath) {
            imageResizer.createIconsForProject(iconsData: iconsData, destination: subPath)
        }
    }
}
