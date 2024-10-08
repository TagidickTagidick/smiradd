import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct SettingsAvatarView: View {
    @Binding var image: UIImage?
    @Binding var imageUrl: String
    @Binding var videoUrl: URL?
    
    @State private var showImagePicker: Bool = false
    @State private var showDocumentPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        Menu {
            Button(
                "Сделать снимок",
                action: {
                self.showImagePicker = true
                self.sourceType = .camera
            }
            )
            Button(
                "Выбрать из галереи",
                action: {
                self.showImagePicker = true
                self.sourceType = .photoLibrary
            }
            )
            Button(
                "Выбрать из файлов",
                action: {
                self.showDocumentPicker = true
            }
            )
                } label: {
                    ZStack (alignment: .bottomTrailing) {
                        if self.image == nil {
                            if self.imageUrl.isEmpty {
                                Image("avatar")
                                    .resizable()
                                    .frame(
                                        width: 128,
                                        height: 128
                                    )
                                    .clipShape(Circle())
                            }
                            else {
                                WebImage(
                                    url: URL(
                                        string: self.imageUrl
                                    )
                                ) { image in
                                        image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(
                                            width: 128,
                                            height: 128
                                        )
                                        .clipped()
                                        .clipShape(Circle())
                                    } placeholder: {
                                            ProgressView()
                                    }
                                    .frame(
                                        width: 128,
                                        height: 128
                                    )
                                    .clipShape(Circle())
                            }
                        }
                        else {
                            Image(uiImage: image!)
                                .resizable()
                                .frame(
                                    width: 128,
                                    height: 128
                                )
                                .clipShape(Circle())
                        }
                        ZStack {
                            Image("edit")
                                .resizable()
                                .frame(
                                    width: 24,
                                    height: 24
                                )
                        }
                        .frame(
                            width: 40,
                            height: 40
                        )
                        .background(.white.opacity(0.6))
                        .clipShape(Circle())
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(
                        image: $image,
                        videoUrl: $imageUrl,
                        sourceType: sourceType
                    )
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPickerView(
                        image: $image,
                        imageUrl: $imageUrl
                    )
                }
    }
}
