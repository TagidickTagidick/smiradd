import SwiftUI
import PhotosUI

struct ServicePageView: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    @State private var pageType: PageType = .matchNotFound

    @State private var image: UIImage?
    @State private var imageUrl: String?
    
    @State private var name: String = ""
    @FocusState private var nameIsFocused: Bool
    
    @State private var description: String = ""
    @FocusState private var descriptionIsFocused: Bool
    
    @State private var price: String = ""
    @FocusState private var priceIsFocused: Bool
    
    @State private var isAlert = false
    
    var body: some View {
        if pageType == .loading {
            VStack {
                CustomAppBar(
                    title: "Создание услуги",
                    action: {
                        self.viewModel.closeServices()
                    }
                )
                Spacer()
                ProgressView()
                Spacer()
            }
            .padding(
                [.horizontal],
                20
            )
        }
        else {
            ScrollView {
                VStack (alignment: .leading) {
                    CustomAppBar(title: "Создание услуги")
                    ServiceImageView(
                        image: $image,
                        imageUrl: $imageUrl
                    )
                    Spacer()
                        .frame(height: 20)
                    Text("Название*")
                        .font(
                            .custom(
                                "OpenSans-Medium",
                                size: 14
                            )
                        )
                        .foregroundStyle(textAdditional)
                    Spacer()
                        .frame(height: 12)
                    CustomTextField(
                        value: $name,
                        hintText: "Введите название достижения",
                        focused: $nameIsFocused
                    )
                    .onTapGesture {
                        nameIsFocused = true
                    }
                    Spacer()
                        .frame(height: 20)
                    Text("Описание*")
                        .font(
                            .custom(
                                "OpenSans-Medium",
                                size: 14
                            )
                        )
                        .foregroundStyle(textAdditional)
                    Spacer()
                        .frame(height: 12)
                    CustomTextField(
                        value: $description,
                        hintText: "Кратко опишите достижение",
                        focused: $descriptionIsFocused,
                        height: 177,
                        limit: 300,
                        isLongText: true
                    )
                    .onTapGesture {
                        descriptionIsFocused = true
                    }
                    Spacer()
                        .frame(height: 20)
                    Text("Стоимость")
                        .font(
                            .custom(
                                "OpenSans-Medium",
                                size: 14
                            )
                        )
                        .foregroundStyle(textAdditional)
                    Spacer()
                        .frame(height: 12)
                    CustomTextField(
                        value: $price,
                        hintText: "Введите сумму в рублях",
                        focused: $priceIsFocused,
                        limit: 7
                    )
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        priceIsFocused = true
                    }
                    .onChange(of: price) {
                        if price.count > 3 && price.count < 8{
                            price = price.replacingOccurrences(of: " ", with: "")
                            let indexToAdd = price.index(
                                before: price.index(
                                    price.endIndex,
                                    offsetBy: -2
                                )
                            )
                            price.insert(contentsOf: " ", at: indexToAdd)
                        }
                    }
                    if self.viewModel.serviceIndex != -1 {
                        DeleteWidget(text: "услугу")
                            .onTapGesture {
                                isAlert.toggle()
                            }
                            .customAlert(
                                            "Удалить?",
                                            isPresented: $isAlert,
                                            actionText: "Удалить"
                                        ) {
                                            self.viewModel.deleteService()
                                        } message: {
                                            Text("Усдуга и вся информация в ней будут удалены. Удалить услугу?")
                                        }
                    }
                    Spacer()
                        .frame(height: 32)
                    CustomButton(
                        text: "Сохранить",
                        color: !name.isEmpty
                        && !description.isEmpty
                        && (image != nil || imageUrl != nil)
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
                        self.viewModel.saveService(
                            image: image,
                            imageUrl: imageUrl!,
                            name: name,
                            description: description,
                            price: price
                        )
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
            .onAppear {
                self.imageUrl = self.viewModel.serviceIndex == -1 ? "" : self.viewModel.services[self.viewModel.serviceIndex].coverUrl
                self.name = self.viewModel.serviceIndex == -1 ? "" : self.viewModel.services[self.viewModel.serviceIndex].name
                self.description = self.viewModel.serviceIndex == -1 ? "" : self.viewModel.services[self.viewModel.serviceIndex].description
                self.price = self.viewModel.serviceIndex == -1 ? "" : String(self.viewModel.services[self.viewModel.serviceIndex].price)
            }
            .onTapGesture {
                nameIsFocused = false
                descriptionIsFocused = false
                priceIsFocused = false
            }
        }
    }
}


