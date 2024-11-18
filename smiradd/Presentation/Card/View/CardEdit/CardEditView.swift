import SwiftUI
import PhotosUI
import Combine

struct CardEditView: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @FocusState var jobTitleIsFocused: Bool
    @FocusState var specificityIsFocused: Bool
    @FocusState var nameIsFocused: Bool
    @FocusState var phoneIsFocused: Bool
    @FocusState var emailIsFocused: Bool
    @FocusState var addressIsFocused: Bool
    @FocusState var seekIsFocused: Bool
    @FocusState var usefulIsFocused: Bool
    @FocusState var telegramIsFocused: Bool
    @FocusState var vkIsFocused: Bool
    @FocusState var siteIsFocused: Bool
    @FocusState var cvIsFocused: Bool
    @FocusState var showLogoPicker: Bool
    @FocusState var bioIsFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                CardImageView(
                    image: $viewModel.avatarImage,
                    video: $viewModel.avatarVideo,
                    imageUrl: $viewModel.avatarUrl,
                    trailing: nil,
                    onTapTrailing: nil,
                    editButton: false,
                    onTapEditButton: {
                        self.viewModel.changeCardType()
                    }
                )
                .frame(height: 360)
                VStack (alignment: .leading) {
                    VStack (alignment: .leading) {
                        CardEditJobTitleView(
                            jobTitleIsFocused: _jobTitleIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditSpecificityView()
                        Spacer()
                            .frame(height: 16)
                        CardEditNameView(
                            nameIsFocused: _nameIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditPhoneView(
                            phoneIsFocused: _phoneIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditEmailView(
                            emailIsFocused: _emailIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditSeekView(
                            seekIsFocused: _seekIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditUsefulView(
                            usefulIsFocused: _usefulIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditAddressView(
                            addressIsFocused: _addressIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditTelegramView(
                            telegramIsFocused: _telegramIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditVKView(
                            vkIsFocused: _vkIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditSiteView(
                            siteIsFocused: _siteIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditCVView(
                            cvIsFocused: _cvIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CardEditLogoView()
                        Spacer()
                            .frame(width: 16)
                        CardEditBioView(
                            bioIsFocused: _bioIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CustomTextView(
                            text: "Шаблон визитки"
                        )
                        Spacer()
                            .frame(height: 12)
                        CardTemplateView(
                            cardModel: self.commonViewModel.cardModel
                        )
                        .onTapGesture {
                            self.viewModel.openTemplates()
                        }
                    }
                }
                .padding([.horizontal], 20)
                Spacer()
                    .frame(height: 16)
                CardServicesTileView()
                Spacer()
                    .frame(height: 16)
                CardAchievementsTileView()
                Spacer()
                    .frame(height: 32)
                VStack (alignment: .leading) {
                    if self.viewModel.cardType == .editCard && self.commonViewModel.cardModel.is_default == false {
                        DeleteView(text: "визитку")
                            .onTapGesture {
                                self.viewModel.openAlert()
                            }
                            .customAlert(
                                "Удалить визитку?",
                                isPresented: self.$viewModel.isAlert,
                                actionText: "Удалить"
                            ) {
                                self.viewModel.deleteCard()
                            } message: {
                                Text("Визитка и вся информация в ней будут удалены. Удалить визитку?")
                            }
                        Spacer()
                            .frame(height: 32)
                    }
                    CustomButtonView(
                        text: "Сохранить",
                        color: self.viewModel.isValidButton
                        ? Color(
                            red: 0.408,
                            green: 0.784,
                            blue: 0.58
                        ) : Color(
                            red: 0.867,
                            green: 0.867,
                            blue: 0.867
                        )
                    )
                    .onTapGesture {
                        self.viewModel.startSave()
                    }
                    Spacer()
                        .frame(
                            height: 74 + safeAreaInsets.bottom
                        )
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
            .padding([.vertical], 16)
        }
        .background(.white)
        .onTapGesture {
            self.jobTitleIsFocused = false
            self.specificityIsFocused = false
            self.nameIsFocused = false
            self.phoneIsFocused = false
            self.emailIsFocused = false
            self.addressIsFocused = false
            self.seekIsFocused = false
            self.usefulIsFocused = false
            self.telegramIsFocused = false
            self.vkIsFocused = false
            self.siteIsFocused = false
            self.cvIsFocused = false
            self.bioIsFocused = false
        }
    }
}
