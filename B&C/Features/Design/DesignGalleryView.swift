import SwiftUI

struct DesignGalleryView: View {
    var body: some View {
        List {
            if DesignFrame.all.isEmpty {
                ContentUnavailableView(
                    "Нет кадров макета",
                    systemImage: "photo.on.rectangle.angled",
                    description: Text("Экспортируйте кадры из Figma в PNG и добавьте их в Assets.xcassets. Затем перечислите имена ассетов в DesignFrame.all.")
                )
            } else {
                ForEach(DesignFrame.all) { frame in
                    NavigationLink(frame.title) {
                        DesignFrameView(frame: frame)
                    }
                }
            }
        }
        .navigationTitle("Кадры макета")
    }
}

private struct DesignFrameView: View {
    let frame: DesignFrame

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            Image(frame.assetName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(16)
        }
        .navigationTitle(frame.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { DesignGalleryView() }
}
