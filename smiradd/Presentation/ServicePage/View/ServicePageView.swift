import SwiftUI
import PhotosUI

struct ServicePageView: View {
    private var index: Int = -1
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @EnvironmentObject private var navigationService: NavigationService
    
    @EnvironmentObject var cardViewModel: CardViewModel
    
    @StateObject var viewModel: ServiceViewModel
    
    @FocusState private var nameIsFocused: Bool
    
    @FocusState private var descriptionIsFocused: Bool
    
    @FocusState private var priceIsFocused: Bool
    
    init(
        index: Int,
        commonViewModel: CommonViewModel
    ) {
        self.index = index
        _viewModel = StateObject(
            wrappedValue: ServiceViewModel(
                index: index,
                commonViewModel: commonViewModel
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                CustomAppBarView(
                    title: "Создание услуги"
                )
                ServiceImageView(
                    image: $viewModel.coverImage,
                    video: $viewModel.coverVideo,
                    url: $viewModel.coverUrl
                )
                Spacer()
                    .frame(height: 20)
                CustomTextView(
                    text: "Название",
                    isRequired: true
                )
                Spacer()
                    .frame(height: 12)
                CustomTextFieldView(
                    value: $viewModel.name,
                    hintText: "Введите название услуги",
                    focused: $nameIsFocused,
                    limit: 30,
                    showCount: true
                )
                .onTapGesture {
                    nameIsFocused = true
                }
                Spacer()
                    .frame(height: 20)
                CustomTextView(
                    text: "Описание",
                    isRequired: true
                )
                Spacer()
                    .frame(height: 12)
                CustomTextFieldView(
                    value: $viewModel.description,
                    hintText: "Кратко опишите услугу",
                    focused: $descriptionIsFocused,
                    height: 177,
                    limit: 80,
                    isLongText: true,
                    showCount: true
                )
                .onTapGesture {
                    descriptionIsFocused = true
                }
                Spacer()
                    .frame(height: 20)
                CustomTextView(text: "Стоимость")
                Spacer()
                    .frame(height: 12)
                CustomTextFieldView(
                    value: $viewModel.price,
                    hintText: "Введите сумму в рублях",
                    focused: $priceIsFocused,
                    limit: 7
                )
                .keyboardType(.numberPad)
                .onTapGesture {
                    priceIsFocused = true
                }
                .onChange(of: self.viewModel.price) {
                    self.viewModel.onChangePrice()
                }
                if self.index != -1 {
                    DeleteView(text: "услугу")
                        .onTapGesture {
                            self.viewModel.openDeleteAlert()
                        }
                        .customAlert(
                            "Удалить?",
                            isPresented: $viewModel.isAlert,
                            actionText: "Удалить"
                        ) {
                            self.commonViewModel.deleteService(
                                index: index
                            )
                            
                            self.navigationService.navigateBack()
                        } message: {
                            Text("Услуга и вся информация в ней будут удалены. Удалить услугу?")
                        }
                }
                Spacer()
                    .frame(height: 32)
                CustomButtonView(
                    text: "Сохранить",
                    color: !self.viewModel.name.isEmpty
                    && !self.viewModel.description.isEmpty
                    ? Color(
                        red: 0.408,
                        green: 0.784,
                        blue: 0.58
                    ) : Color(
                        red: 0.867,
                        green: 0.867,
                        blue: 0.867
                    )
                ).onTapGesture {
                    self.commonViewModel.saveService(
                        index: index,
                        coverUrl: self.viewModel.coverUrl,
                        coverImage: self.viewModel.coverImage,
                        coverVideo: self.viewModel.coverVideo,
                        name: self.viewModel.name,
                        description: self.viewModel.description,
                        price: self.viewModel.price
                    )
                    
                    self.navigationService.navigateBack()
                }
                Spacer()
                    .frame(height: 74)
            }
            .padding(
                [.horizontal],
                20
            )
        }
        .navigationBarHidden(true)
        .background(.white)
        .onTapGesture {
            nameIsFocused = false
            descriptionIsFocused = false
            priceIsFocused = false
        }
    }
}


