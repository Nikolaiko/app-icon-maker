import SwiftUI

struct ProjectResourcePathView: View {
    @Binding var path: String
    let selectCallback: VoidCallback
    
    var body: some View {
        HStack {
            TitleText(text: ".xcasset file path:")
            TextField("Select xcasset file path", text: $path)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            BlueButton(buttonTitle: "Select", callback: selectCallback)
        }
    }
}

struct ProjectResourcePathView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectResourcePathView(path: .constant("Some"), selectCallback: {})
    }
}
