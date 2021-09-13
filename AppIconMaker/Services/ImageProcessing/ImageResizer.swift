import SwiftUI

final class ImageResizer {
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
}
