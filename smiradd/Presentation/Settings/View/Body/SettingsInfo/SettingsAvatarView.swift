import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct SettingsAvatarView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    
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
                        if self.viewModel.pictureImage != nil {
                            Image(uiImage: self.viewModel.pictureImage!)
                                .resizable()
                                .frame(
                                    width: 128,
                                    height: 128
                                )
                                .clipShape(Circle())
                        }
                        else if self.viewModel.pictureVideo != nil {
                            WebImage(
                                url: self.viewModel.pictureVideo!
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
                        else if !self.viewModel.pictureUrl.isEmpty {
                            WebImage(
                                url: URL(
                                    string: self.viewModel.pictureUrl
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
                        else {
                            Image("avatar")
                                .resizable()
                                .frame(
                                    width: 128,
                                    height: 128
                                )
                                .clipShape(Circle())
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(
                        image: self.$viewModel.pictureImage,
                        videoUrl: self.$viewModel.pictureUrl,
                        sourceType: self.sourceType
                    )
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPickerView(
                        image: self.$viewModel.pictureImage,
                        video: self.$viewModel.pictureVideo
                    )
                }
    }
}
