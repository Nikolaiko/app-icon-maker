import SwiftUI

struct ImagePathView: View {
    
    @Binding var path: String
    let selectCallback: VoidCallback
    
    var body: some View {
        HStack {
            TitleText(text: "Destination path:")
            TextField("Enter destination path", text: $path)
            BlueButton(buttonTitle: "Select", callback: selectCallback)
        }
    }
}

struct ImagePathView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePathView(path: .constant("SomePath"), selectCallback: {})
    }
}
