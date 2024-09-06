import SwiftUI
import PhotosUI

struct ServiceImageView: View {
    @Binding var image: UIImage?
    @Binding var imageUrl: String?
    
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
                    ZStack {
                        if self.imageUrl != nil {
                            AsyncImage(
                                url: URL(
                                    string: self.imageUrl!
                                )
                            ) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(
                                width: UIScreen.main.bounds.width - 40,
                                height: 200
                                )
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
                            Text(self.image == nil || self.imageUrl == nil ? "Загрузить обложку" : "Изменить обложку")
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
                .sheet(isPresented: $showPicker) {
                    ImagePickerView(image: $image, sourceType: sourceType)
                }
    }
}
