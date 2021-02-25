import SwiftUI

final class ImageResizer {
    private let sizes: [Int] = [
        1024,
        512,
        256,
        180,
        128,
        120,
        87,
        80,
        64,
        60,
        58,
        40,
        32,
        29,
        16
    ]
    
    func resizeImageToIcons(sourceUrl: URL, sourceFileName: String) {
        let selectFolderPanel = NSOpenPanel()
        selectFolderPanel.title = NSLocalizedString("Select folder for new icons", comment: "enableFileMenuItems")
        selectFolderPanel.canCreateDirectories = true
        selectFolderPanel.canChooseDirectories = true
        selectFolderPanel.prompt = NSLocalizedString("Select folder", comment: "enableFileMenuItems")
        selectFolderPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                for currentDimension in self.sizes {
                    let resized = NSImage(contentsOf: sourceUrl)!.resizedCopy(
                        w: CGFloat(currentDimension),
                        h: CGFloat(currentDimension)
                    )
                    let fileName = selectFolderPanel.url!.appendingPathComponent(
                        "\(sourceFileName)-\(currentDimension).jpeg"
                    )
                    resized.writeJPEG(toURL: fileName)
                }
            }
        }
    }
}
