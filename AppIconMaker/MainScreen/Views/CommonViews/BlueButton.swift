import SwiftUI

struct BlueButton: View {
    let buttonTitle: String
    let callback: VoidCallback
    
    var body: some View {
        Button(action: callback) {
            Text(buttonTitle)
        }
        .background(Color.blue)
    }
}

struct BlueButton_Previews: PreviewProvider {
    static var previews: some View {
        BlueButton(buttonTitle: "Button", callback: {})
    }
}
