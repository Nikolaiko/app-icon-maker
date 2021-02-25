import SwiftUI

struct ContentView: View, DropDelegate {
    @State private var url: URL?
    @State private var iconFileName: String = ""

    var body: some View {
        HStack {
            VStack {
                Text("Icon files name")
                TextField("Enter icon files name", text: $iconFileName)
                    .frame(width: AppConsts.IMAGE_PREVIEW_SIDE)
                    .padding(.leading, AppConsts.IMAGE_PREVIEW_SIDE * 0.01)
                    .disabled(url == nil)
                Button(action: saveResizedCopy, label: {
                    Text("Create icons")
                })
                .disabled(url == nil)
                Button(action: selectImageForPhoto, label: {
                    Text("Select file for icon")
                })
            }
            buildImagePreview()
        }
    }
    
    func selectImageForPhoto() {
        let selectImagePanel = NSOpenPanel()
        selectImagePanel.title = NSLocalizedString("Select image for new icons", comment: "enableFileMenuItems")
        selectImagePanel.prompt = NSLocalizedString("Select image", comment: "enableFileMenuItems")
        selectImagePanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                updateSelectedUrl(newUrl: selectImagePanel.url!)
            }
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider: NSItemProvider = info.itemProviders(for: [.fileURL]).first else { return false }
        itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { item, _ in
            guard
                let data = item as? Data,
                let parsedUrl = URL(dataRepresentation: data, relativeTo: nil) else { return }
            updateSelectedUrl(newUrl: parsedUrl)
        }
        return info.hasItemsConforming(to: [.fileURL])
    }

    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: [.fileURL])
    }
    
    private func saveResizedCopy() {
        ImageResizer().resizeImageToIcons(sourceUrl: url!, sourceFileName: iconFileName)
    }

    private func updateSelectedUrl(newUrl: URL) {
        url = newUrl
        guard
            let filename = url?.pathComponents.last,
            let namePart = filename.split(separator: ".").first
        else { return }
        
        iconFileName = String(namePart)
    }
    
    @ViewBuilder private func buildImagePreview() -> some View {
        if url != nil {
            Image(nsImage: NSImage(contentsOf: url!)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: AppConsts.IMAGE_PREVIEW_SIDE, height: AppConsts.IMAGE_PREVIEW_SIDE)
                .background(Color.black)
                .onDrop(of: [.fileURL], delegate: self)
        } else {
            Image("preview")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: AppConsts.IMAGE_PREVIEW_SIDE, height: AppConsts.IMAGE_PREVIEW_SIDE)
                .clipped()
                .background(Color.black)
                .onDrop(of: [.fileURL], delegate: self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
