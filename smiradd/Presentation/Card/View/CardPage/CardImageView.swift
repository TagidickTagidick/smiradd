import SwiftUI
import PhotosUI
import SDWebImage
import SDWebImageSwiftUI
import AVKit

struct CardImageView: View {
    @Binding var image: UIImage?
    @Binding var videoUrl: URL?
    @Binding var imageUrl: String
    let showTrailing: Bool
    let editButton: Bool?
    var onTapEditButton: (() -> ())? = nil
    
    @State private var showImagePicker: Bool = false
    @State private var showDocumentPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack {
            if image == nil {
                if imageUrl.isEmpty {
                    Image("avatar")
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: 360
                        )
                }
                else if videoUrl != nil {
//                    VideoPlayer(player: AVPlayer(url: videoUrl!))
////                        .resizable()
////                        .aspectRatio(contentMode: .fill)
//                        .frame(
//                            width: UIScreen.main.bounds.width,
//                            height: 360
//                        )
                    WebImage(
                        url: videoUrl
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
                    WebImage(
                        url: URL(
                            string: imageUrl
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
                    .frame(
                        height: self.safeAreaInsets.top
                    )
                HStack {
                    BackButtonView()
                    Spacer()
                    if self.showTrailing {
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
                                imageUrl: $imageUrl
                            )
                        }
                    }
                }
            }
            .padding([.vertical, .horizontal], 20)
        }
    }
}
