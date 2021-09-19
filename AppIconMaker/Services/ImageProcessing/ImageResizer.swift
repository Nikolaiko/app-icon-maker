import SwiftUI

struct ImageResizer {
    func resizeImageToIcons(
        sourceUrl: URL,
        sourceFileName: String,
        destinationUrl: URL
    ) {
        for currentDimension in AppConsts.ICON_SIZES {
            let resized = NSImage(contentsOf: sourceUrl)!.resizedCopy(
                w: CGFloat(currentDimension),
                h: CGFloat(currentDimension)
            )
            var fileName = destinationUrl
                .appendingPathComponent(sourceFileName)
            
            var isDirectory:ObjCBool = true
            if !FileManager.default.fileExists(atPath: fileName.path, isDirectory: &isDirectory) {
                do {
                    try FileManager.default.createDirectory(
                        at: fileName,
                        withIntermediateDirectories: true,
                        attributes: nil
                    )
                } catch {
                    print("Error creating folder!")
                }
            }
                
            fileName = fileName.appendingPathComponent(
                "\(sourceFileName)-\(currentDimension).jpeg"
            )
            resized.writeJPEG(toURL: fileName)
        }
    }
    
    func createIconsForProject(
        source: URL,
        destination: URL,
        imagesData: [IconImage]
    ) -> [IconImage] {
        var addedFileUrls: [URL] = []
        var addedFileNames: [String] = []
        var imagesDataCopy = imagesData
                
        for i in imagesData.indices {
            let currentSize = imagesData[i].toCGSize()
            let sourceImage = NSImage(contentsOf: source)!
            let resizedCopy = sourceImage.resizedCopy(
                w: currentSize.width,
                h: currentSize.height
            )
            let fileName = "IconImage-\(currentSize.width).jpeg"
            let destFileUrl = destination.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: destFileUrl.path) {
                do {
                    try FileManager.default.removeItem(at: destFileUrl)
                } catch {
                    print("Error during removing file \(error)")
                }
            }
            resizedCopy.writeJPEG(toURL: destFileUrl)
            addedFileUrls.append(destFileUrl)
            addedFileNames.append(fileName)
            imagesDataCopy[i].filename = fileName
        }
        return imagesDataCopy
    }
}
