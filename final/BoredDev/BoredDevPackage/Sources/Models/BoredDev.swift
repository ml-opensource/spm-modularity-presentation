import Foundation
import SwiftUI

public struct BoredDev: Equatable, Identifiable {
    public let id = UUID()
    public var name: String
    public var color: Color?

    public init(name: String, color: Color? = nil) {
        self.name = name
        self.color = color
    }
}

public extension BoredDev {
    func duplicate() -> Self {
        .init(name: self.name, color: self.color)
    }
}
