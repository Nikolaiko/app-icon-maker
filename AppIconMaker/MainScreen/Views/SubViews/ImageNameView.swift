import SwiftUI

struct ImageNameView: View {
    @Binding var imageName: String
    
    var body: some View {
        HStack {
            TitleText(text: "Icon files name:")
            TextField("Enter icon files name", text: $imageName)
        }
    }
}

struct ImageNameView_Previews: PreviewProvider {
    static var previews: some View {
        ImageNameView(imageName: .constant("Some name"))
    }
}
