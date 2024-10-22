import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct CardEditLogoView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @State private var showImagePicker: Bool = false
    @State private var showDocumentPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        HStack {
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
                if self.viewModel.logoImage != nil {
                    Image(uiImage: self.viewModel.logoImage!)
                        .resizable()
                        .frame(
                            width: 80,
                            height: 80
                        )
                        .cornerRadius(16)
                }
                else if self.viewModel.logoVideo != nil {
                    WebImage(
                        url: self.viewModel.logoVideo
                    ) { image in
                            image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: 80,
                                height: 80
                            )
                            .clipped()
                            .cornerRadius(16)
                        } placeholder: {
                                Rectangle().foregroundColor(.gray)
                        }
                }
                else if !self.viewModel.logoUrl.isEmpty {
                    WebImage(
                        url: URL(
                            string: self.viewModel.logoUrl
                        )
                    ) { image in
                            image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: 80,
                                height: 80
                            )
                            .clipped()
                            .cornerRadius(16)
                        } placeholder: {
                                Rectangle().foregroundColor(.gray)
                        }
                }
                else {
                    ZStack {
                        Image(systemName: "plus")
                            .frame(
                                width: 36,
                                height: 36
                            )
                            .foregroundStyle(textAdditional)
                    }
                    .frame(
                        width: 80,
                        height: 80
                    )
                    .background(accent50)
                    .cornerRadius(16)
                }
            }
            Spacer()
                .frame(width: 16)
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
                CardButtonView(
                    image: "edit",
                    text: "Изменить логотип"
                )
                .frame(
                    minWidth: UIScreen.main.bounds.width - 152,
                    minHeight: 48
                )
                .background(accent50)
                .cornerRadius(24)
            }
        }
        .sheet(isPresented: self.$showImagePicker) {
            ImagePickerView(
                image: self.$viewModel.logoImage,
                videoUrl: self.$viewModel.logoUrl,
                sourceType: self.sourceType
            )
        }
        .sheet(isPresented: self.$showDocumentPicker) {
            DocumentPickerView(
                image: self.$viewModel.logoImage,
                video: self.$viewModel.logoVideo
            )
        }
    }
}
