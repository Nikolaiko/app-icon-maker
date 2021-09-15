import Foundation

struct XCAssetsParser {
    func parse(destination: URL) -> AppIcons? {
        var icons: AppIcons? = nil
        do {
            let jsonData = try Data(contentsOf: destination)
            icons = try JSONDecoder().decode(AppIcons.self, from: jsonData)
        } catch {
            print("Error during file read or parse : \(error)")
        }
        return icons
    }
}
