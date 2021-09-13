import SwiftUI

struct TitleText: View {
    private static let titleTextSize: CGFloat = 14.0
    
    let text: String
    
    var body: some View {
        Text(text)
            .bold()
            .font(.system(size: TitleText.titleTextSize))
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        TitleText(text: "Some")
    }
}
