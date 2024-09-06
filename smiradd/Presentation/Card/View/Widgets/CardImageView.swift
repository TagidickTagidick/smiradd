import SwiftUI
import PhotosUI

struct CardImageView: View {
    @Binding var image: UIImage?
    @Binding var imageUrl: String?
    let showButton: Bool
    
    @State private var showPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack {
            if image == nil {
                if imageUrl != nil {
                    AsyncImage(
                        url: URL(
                            string: imageUrl!
                        )
                    ) { image in
                        image
                            .resizable()
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: 360
                            )
                    } placeholder: {
                        ProgressView()
                    }
                }
                else {
                    Image("avatar")
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: 360
                        )
                }
            }
            else {
                Image(uiImage: image!)
                    .resizable()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: 360
                    )
            }
            VStack {
                Spacer()
                    .frame(height: safeAreaInsets.top)
                HStack {
                    BackButton()
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.4))
                            .frame(
                                width: 48,
                                height: 48
                            )
                        Image("unlock")
                            .foregroundColor(Color(
                                red: 0.8,
                                green: 0.8,
                                blue: 0.8
                            ))
                    }
                }
                Spacer()
                if (showButton) {
                    Menu {
                        Button(
                            "Сделать снимок",
                            action: {
                                self.showPicker = true
                                self.sourceType = .camera
                            }
                        )
                        Button(
                            "Выбрать из галереи",
                            action: {
                                self.showPicker = true
                                self.sourceType = .photoLibrary
                            }
                        )
                    } label: {
                        ZStack {
                            HStack {
                                Image("edit")
                                Spacer()
                                    .frame(width: 10)
                                Text("Загрузить фотографию")
                                    .font(
                                        .custom(
                                            "OpenSans-SemiBold",
                                            size: 16
                                        )
                                    )
                                    .foregroundStyle(textDefault)
                            }
                            .frame(
                                minWidth: UIScreen.main.bounds.width - 40,
                                minHeight: 48
                            )
                            .background(.white.opacity(0.4))
                            .cornerRadius(28)
                        }
                    }
                    .sheet(isPresented: $showPicker) {
                        ImagePickerView(image: $image, sourceType: sourceType)
                    }
                }
            }
            .padding([.vertical, .horizontal], 20)
        }
    }
}
