import Foundation
import SwiftUI
import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        register { ImageResizer() }
        register { MainViewModel() }
        register { XCAssetsParser() }
    }
}
