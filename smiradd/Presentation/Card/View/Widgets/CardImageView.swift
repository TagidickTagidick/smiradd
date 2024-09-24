import SwiftUI
import PhotosUI
import SDWebImage
import SDWebImageSwiftUI

struct CardImageView: View {
    @Binding var image: UIImage?
    @Binding var imageUrl: String
    let showTrailing: Bool
    let editButton: Bool?
    var onTapEditButton: (() -> ())? = nil
    
    @State private var showPicker: Bool = false
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
                else {
                    WebImage(
                        url: URL(
                            string: imageUrl
                        )
                    ) { image in
                            image
                            .resizable()
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: 360
                            )
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
                        .sheet(isPresented: $showPicker) {
                            ImagePickerView(image: $image, sourceType: sourceType)
                        }
                    }
                }
            }
            .padding([.vertical, .horizontal], 20)
        }
    }
}
