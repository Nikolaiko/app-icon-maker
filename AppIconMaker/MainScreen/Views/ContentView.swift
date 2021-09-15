import SwiftUI
import Resolver

struct ContentView: View, DropDelegate {    
    @InjectedObject var viewModel: MainViewModel
    
    var body: some View {
        if viewModel.imageFileSelected {
            buildViewWithImage()
        } else {
            buildEmptyView()
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider: NSItemProvider = info.itemProviders(for: [.fileURL]).first else { return false }
        itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { item, _ in
            guard
                let data = item as? Data,
                let parsedUrl = URL(dataRepresentation: data, relativeTo: nil)
            else { return }
            DispatchQueue.main.async {
                self.viewModel.updateImageUrl(imageUrl: parsedUrl)
            }
        }
        return info.hasItemsConforming(to: [.fileURL])
    }

    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: [.fileURL])
    }
    
    private func selectImageForPhoto() {
        let selectImagePanel = NSOpenPanel()
        selectImagePanel.title = NSLocalizedString("Select image for new icons", comment: "enableFileMenuItems")
        selectImagePanel.prompt = NSLocalizedString("Select image", comment: "enableFileMenuItems")
        selectImagePanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                DispatchQueue.main.async {
                    viewModel.updateImageUrl(imageUrl: selectImagePanel.url!)
                }
            }
        }
    }
    
    private func selectFolderForIcon() {
        let dialog = NSOpenPanel();
        dialog.title = "Choose directory for result icons";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            DispatchQueue.main.async {
                viewModel.updateDestinationUrl(newUrl: dialog.url!)
            }
        }
    }
    
    private func selectProjectImageSetFile() {
        let dialog = NSOpenPanel();
        dialog.title = "Select Assets.xcassets folder";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            DispatchQueue.main.async {
                viewModel.updateProjectDestinationURL(newUrl: dialog.url!)
            }
        }
    }
    
    private func buildViewWithImage() -> some View {
        HStack {
            VStack {
                GroupBox(
                    label: TitleText(text: "Image Selection"),
                    content: {
                        VStack {
                            ImageNameView(imageName: $viewModel.imageFileName)
                            BlueButton(
                                buttonTitle: "Select different image",
                                callback: selectImageForPhoto
                            )
                        }
                    }
                )
                GroupBox(
                    label: TitleText(text: "Create Icons"),
                    content: {
                        VStack {
                            ImagePathView(
                                path: $viewModel.destinationPath,
                                selectCallback: selectFolderForIcon
                            )
                            if viewModel.destinationPath != "" {
                                BlueButton(buttonTitle: "Create",
                                           callback: viewModel.generateIcons
                                )
                            }
                        }
                    }
                )
                GroupBox(
                    label: TitleText(text: "Add to existing project"),
                    content: {
                        VStack {
                            ProjectResourcePathView(
                                path: $viewModel.projectDestinationPath,
                                selectCallback: selectProjectImageSetFile
                            )
                            if viewModel.projectDestinationPath != "" {
                                BlueButton(buttonTitle: "Add to project",
                                           callback: viewModel.importIconsToProject
                                )
                            }
                        }
                    }
                )
            }
            .padding(.horizontal, 5.0)
            .frame(
                width: AppConsts.IMAGE_PREVIEW_SIDE,
                height: AppConsts.IMAGE_PREVIEW_SIDE
            )
            Image(nsImage: NSImage(contentsOf: viewModel.imageFileUrl!)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: AppConsts.IMAGE_PREVIEW_SIDE,
                    height: AppConsts.IMAGE_PREVIEW_SIDE
                )
                .background(Color.black)
                .onDrop(of: [.fileURL], delegate: self)
        }
    }
    
    private func buildEmptyView() -> some View {
        HStack {
            HStack {
                BlueButton(
                    buttonTitle: "Select file for icon",
                    callback: selectImageForPhoto)
            }
            .frame(
                width: AppConsts.IMAGE_PREVIEW_SIDE,
                height: AppConsts.IMAGE_PREVIEW_SIDE
            )
            Image("preview")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: AppConsts.IMAGE_PREVIEW_SIDE,
                       height: AppConsts.IMAGE_PREVIEW_SIDE)                
                .background(Color.black)
                .onDrop(of: [.fileURL], delegate: self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()    
        }
    }
}
