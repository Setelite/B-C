import Foundation

struct DesignFrame: Identifiable, Hashable {
    let id: String
    let title: String
    let assetName: String

    init(id: String, title: String, assetName: String) {
        self.id = id
        self.title = title
        self.assetName = assetName
    }
}

extension DesignFrame {
    /// Заполните этот массив именами ассетов (PNG), которые вы добавите из Figma.
    static let all: [DesignFrame] = []
}
