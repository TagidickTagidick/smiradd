import SwiftUI
import PhotosUI

struct CardLogoView: View {
    @Binding var image: UIImage?
    @Binding var imageUrl: String
    
    @State private var showPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        HStack {
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
                if image == nil {
                    if imageUrl.isEmpty {
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
                    else {
                        AsyncImage(
                            url: URL(
                                string: imageUrl
                            )
                        ) { image in
                            image
                                .resizable()
                                .frame(
                                    width: 80,
                                    height: 80
                                )
                                .background(accent50)
                                .cornerRadius(16)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                else {
                    Image(uiImage: image!)
                        .resizable()
                        .frame(
                            width: 80,
                            height: 80
                        )
                        .cornerRadius(16)
                }
            }
            .sheet(isPresented: $showPicker) {
                ImagePickerView(image: $image, sourceType: sourceType)
            }
            Spacer()
                .frame(width: 16)
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
    }
}
