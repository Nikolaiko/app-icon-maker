import SwiftUI

struct ImagePathView: View {
    
    @Binding var path: String
    let selectCallback: VoidCallback
    
    var body: some View {
        HStack {
            TitleText(text: "Destination path:")
            TextField("Select destination path", text: $path)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            BlueButton(buttonTitle: "Select", callback: selectCallback)
        }
    }
}

struct ImagePathView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePathView(path: .constant("SomePath"), selectCallback: {})
    }
}
