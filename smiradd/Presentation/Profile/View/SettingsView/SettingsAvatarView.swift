import SwiftUI

struct SettingsAvatarView: View {
    @Binding var image: UIImage?
    @Binding var imageUrl: String
    
    @State private var showPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        Menu {
            Button("Сделать снимок", action: {
                self.showPicker = true
                self.sourceType = .camera
            })
            Button("Выбрать из галереи", action: {
                self.showPicker = true
                self.sourceType = .photoLibrary
            })
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
                                AsyncImage(
                                    url: URL(
                                        string: self.imageUrl
                                    )
                                ) { image in
                                    image.resizable()
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
                .sheet(isPresented: $showPicker) {
                    ImagePickerView(image: $image, sourceType: sourceType)
                }
    }
}
