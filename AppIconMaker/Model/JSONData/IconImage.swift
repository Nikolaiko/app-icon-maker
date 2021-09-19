import Foundation

struct IconImage: Codable {
    var filename: String?
    let idiom: IconIdiom?
    let scale: IconScale?
    let size: String?
    
    func toCGSize() -> CGSize {
        let intScale = scale?.toInt() ?? 0
        let formatedSize = size?.split(separator: "x").first ?? "1"
        
        let floatSize = Float(formatedSize) ?? 0
        let totalSide = floatSize * Float(intScale)        
        return CGSize(
            width: CGFloat(totalSide),
            height: CGFloat(totalSide)
        )
    }
}
