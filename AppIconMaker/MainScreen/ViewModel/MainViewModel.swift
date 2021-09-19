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
        
        var components = projectDestinationUrl?.pathComponents ?? []
        if components.count >= 2 {
            components = Array(components.dropFirst(components.count - 2))
            projectDestinationPath = "\(components.first ?? "")/\(components.last ?? "")"
        } else {
            projectDestinationPath = "\(components.first ?? "")"
        }
        
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
        
        if var iconsData = parser.parse(destination: jsonFilePath) {
            let resizeResults = imageResizer.createIconsForProject(
                source: imageFileUrl!,
                destination: subPath,
                imagesData: iconsData.images ?? []
            )
            iconsData.images = resizeResults
            
            var initialData: Data? = nil
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(iconsData)
                
                if FileManager.default.fileExists(atPath: jsonFilePath.path) {
                    initialData = try Data(contentsOf: jsonFilePath)
                }
                try jsonData.write(to: jsonFilePath)
            } catch {
                if initialData != nil {
                    try? initialData?.write(to: jsonFilePath)
                }
            }
        }
    }
}
