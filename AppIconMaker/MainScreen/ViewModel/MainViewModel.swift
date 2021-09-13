import SwiftUI
import Combine
import Resolver

class MainViewModel: ObservableObject {
    
    @Injected private var imageResizer: ImageResizer
    
    private var destinationUrl: URL?
    
    @Published private(set) var imageFileUrl: URL?    
    @Published private(set) var imageFileSelected = false
    
    @Published var imageFileName: String = ""
    @Published var destinationPath: String = ""
    
    func updateImageUrl(imageUrl: URL) {
        imageFileUrl = imageUrl
        imageFileSelected = true
        
        let filename: String = imageUrl.pathComponents.last ?? ""
        imageFileName = String(filename.split(separator: ".").first ?? "")
    }
    
    func updateDestinationUrl(newUrl: URL) {
        destinationUrl = newUrl
        guard destinationUrl != nil else { return }
        destinationPath = destinationUrl?.path ?? ""
    }
    
    func generateIcons() {
        imageResizer.resizeImageToIcons(
            sourceUrl: imageFileUrl!,
            sourceFileName: imageFileName,
            destinationUrl: destinationUrl!
        )
    }
}
