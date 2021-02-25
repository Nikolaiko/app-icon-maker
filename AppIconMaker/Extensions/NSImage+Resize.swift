import SwiftUI

extension NSImage {
    func resizedCopy( w: CGFloat, h: CGFloat) -> NSImage {
        let destSize = NSSize(width: w, height: h)
        let newImage = NSImage(size: destSize)
            
        newImage.lockFocus()
            
        self.draw(in: NSRect(origin: .zero, size: destSize),
                  from: NSRect(origin: .zero, size: self.size),
                  operation: .copy,
                  fraction: CGFloat(1))
        
        newImage.unlockFocus()
        guard let data = newImage.tiffRepresentation,
              let result = NSImage(data: data)
        else { return NSImage() }
            
        return result
    }
    
    public func writeJPEG(toURL url: URL) {
        guard let data = tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let imgData = rep.representation(
                using: .jpeg,
                properties: [.compressionFactor: 1.0]
              ) else {
                Swift.print("Error in converting image.")
                return
            }

            do {
                try imgData.write(to: url)
            } catch let error {
                Swift.print("\(self) Error Function '\(#function)' Line: \(#line) \(error.localizedDescription)")
            }
        }
}
