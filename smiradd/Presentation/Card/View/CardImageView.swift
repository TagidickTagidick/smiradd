import SwiftUI
import PhotosUI
import SDWebImage
import SDWebImageSwiftUI
import AVKit

struct CardImageView: View {
    @Binding var image: UIImage?
    @Binding var video: URL?
    @Binding var imageUrl: String
    
    let trailing: String?
    let onTapTrailing: (() -> ())?
    
    let editButton: Bool?
    var onTapEditButton: (() -> ())? = nil
    
    @State private var showImagePicker: Bool = false
    @State private var showDocumentPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack {
            if self.image != nil {
                Image(uiImage: self.image!)
                    .resizable()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: 360
                    )
            }
            else if self.video != nil {
                WebImage(
                    url: self.video
                ) { image in
                        image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: 360
                        )
                        .clipped()
                    } placeholder: {
                            Rectangle().foregroundColor(.gray)
                    }
            }
            else if !self.imageUrl.isEmpty {
                WebImage(
                    url: URL(
                        string: self.imageUrl
                    )
                ) { image in
                        image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: 360
                        )
                        .clipped()
                    } placeholder: {
                            Rectangle().foregroundColor(.gray)
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
            VStack {
                Spacer()
                    .frame(
                        height: self.safeAreaInsets.top
                    )
                HStack {
                    BackButtonView()
                    Spacer()
                    if self.trailing != nil {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.4))
                                .frame(
                                    width: 48,
                                    height: 48
                                )
                            Image(self.trailing!)
                                .foregroundColor(
                                    Color(
                                    red: 0.8,
                                    green: 0.8,
                                    blue: 0.8
                                )
                                )
                        }
                        .onTapGesture {
                            self.onTapTrailing!()
                        }
                    }
                }
                Spacer()
                if self.editButton != nil {
                    if self.editButton! {
                        ZStack {
                            HStack {
                                Image("edit")
                                Spacer()
                                    .frame(width: 10)
                                Text("Редактировать")
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
                        .onTapGesture {
                            self.onTapEditButton!()
                        }
                    }
                    else {
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
                                HStack {
                                    Image("edit")
                                    Spacer()
                                        .frame(width: 10)
                                    Text("Загрузить фотографию/gif")
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
                                video: $video
                            )
                        }
                    }
                }
            }
            .padding([.vertical, .horizontal], 20)
        }
    }
}
