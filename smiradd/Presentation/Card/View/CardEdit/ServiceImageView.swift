import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct ServiceImageView: View {
    @Binding var image: UIImage?
    @Binding var video: URL?
    @Binding var url: String
    
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
                    ZStack {
                        if !self.url.isEmpty {
                            WebImage(
                                url: URL(
                                    string: self.url
                                )
                            ) { image in
                                    image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(
                                        width: UIScreen.main.bounds.width - 40,
                                        height: 200
                                    )
                                    .clipped()
                                } placeholder: {
                                        ProgressView()
                                }
                                .frame(
                                    width: UIScreen.main.bounds.width - 40,
                                    height: 200
                                )
//                            AsyncImage(
//                                url: URL(
//                                    string: self.imageUrl
//                                )
//                            ) { image in
//                                image.resizable()
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .frame(
//                                width: UIScreen.main.bounds.width - 40,
//                                height: 200
//                            )
                        }
                        
                        if image != nil {
                            Image(uiImage: image!)
                                .resizable()
                                .frame(
                                    width: UIScreen.main.bounds.width - 40,
                                    height: 200
                                )
                        }
                        
                        HStack {
                            Image("edit")
                            Spacer()
                                .frame(width: 10)
                            Text(self.image == nil || self.url.isEmpty ? "Загрузить обложку" : "Изменить обложку")
                                .font(
                                    .custom(
                                        "OpenSans-SemiBold",
                                        size: 16
                                    )
                                )
                                .foregroundStyle(textDefault)
                        }
                        .frame(
                            minWidth: UIScreen.main.bounds.width - 92,
                            minHeight: 48
                        )
                        .background(.white.opacity(0.6))
                        .cornerRadius(28)
                    }
                    .frame(
                        minWidth: UIScreen.main.bounds.width - 40,
                        minHeight: 200
                    )
                    .background(textDefault).opacity(0.48)
                    .cornerRadius(16)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(
                        image: $image,
                        videoUrl: $url,
                        sourceType: sourceType
                    )
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPickerView(
                        image: $image,
                        video: $video
                    )
                }
    }
}
