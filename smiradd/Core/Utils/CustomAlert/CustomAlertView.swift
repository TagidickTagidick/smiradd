import SwiftUI

struct CustomAlertView<T: Hashable, M: View>: View {

    @Binding private var isPresented: Bool
    @State private var titleKey: LocalizedStringKey
    @State private var actionTextKey: LocalizedStringKey

    private var data: T?
    private var actionWithValue: ((T) -> ())?
    private var messageWithValue: ((T) -> M)?

    private var action: (() -> ())?
    private var message: (() -> M)?

    @State private var isAnimating = false
    private let animationDuration = 0.5

    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        presenting data: T?,
        actionTextKey: LocalizedStringKey,
        action: @escaping (T) -> (),
        @ViewBuilder message: @escaping (T) -> M
    ) {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented

        self.data = data
        self.action = nil
        self.message = nil
        self.actionWithValue = action
        self.messageWithValue = message
    }

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(isPresented ? 0.6 : 0)
                .zIndex(1)

            if isAnimating {
                VStack {
                    VStack (alignment: .leading) {
                        Text(titleKey)
                            .font(
                                .custom(
                                    "OpenSans-Medium",
                                    size: 14
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                            .frame(height: 16)
                        Group {
                            if let data, let messageWithValue {
                                messageWithValue(data)
                            } else if let message {
                                message()
                            }
                        }
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 14
                            )
                        )
                        .foregroundStyle(textDefault)
                        //.multilineTextAlignment(.center)

                        HStack {
                            Spacer()
                            CancelButton
                            DoneButton
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .padding([.vertical, .horizontal], 20)
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .cornerRadius(16)
                }
                .padding()
                .transition(.moveAndFadeFromBottom)
                .zIndex(2)
                .onTapGesture {}
            }
        }
        .ignoresSafeArea()
        .environment(\.sizeCategory, .medium)
        .onAppear {
            show()
        }
        .onTapGesture {
            dismiss()
        }
    }

    var CancelButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Отмена")
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 16
                    )
                )
                .foregroundStyle(textDefault)
                .foregroundStyle(.tint)
                .padding()
                .lineLimit(1)
                .frame(
                    width: 102,
                    height: 40
                )
                .background(Color(
                    red: 0.949,
                    green: 0.949,
                    blue: 0.949
                ))
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }

    var DoneButton: some View {
        Button {
            dismiss()

            if let data, let actionWithValue {
                actionWithValue(data)
            } else if let action {
                action()
            }
        } label: {
            Text(actionTextKey)
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 16
                    )
                )
                .foregroundStyle(.white)
                .padding()
                .multilineTextAlignment(.center)
                .frame(
                    width: 107,
                    height: 40
                )
                .background(Color(
                    red: 0.898,
                    green: 0.271,
                    blue: 0.267
                ))
                .clipShape(RoundedRectangle(cornerRadius: 30.0))
        }
    }

    func dismiss() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            } completion: {
                isPresented = false
            }
        } else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                isPresented = false
            }
        }
    }

    func show() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isAnimating = true
        }
    }
}

struct ForumCodeView<T: Hashable, M: View>: View {

    @Binding private var isPresented: Bool
    @State private var titleKey: LocalizedStringKey
    @State private var actionTextKey: LocalizedStringKey

    private var data: T?
    private var actionWithValue: ((T) -> ())?
    private var messageWithValue: ((T) -> M)?

    private var action: (() -> ())?
    private var message: (() -> M)?

    @State private var isAnimating = false
    private let animationDuration = 0.5
    
    @Binding private var pinCode: String

    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        _ pinCode: Binding<String>,
        presenting data: T?,
        actionTextKey: LocalizedStringKey,
        action: @escaping (T) -> (),
        @ViewBuilder message: @escaping (T) -> M
    ) {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented
        _pinCode = pinCode

        self.data = data
        self.action = nil
        self.message = nil
        self.actionWithValue = action
        self.messageWithValue = message
    }

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(isPresented ? 0.6 : 0)
                .zIndex(1)

            if isAnimating {
                VStack {
                    VStack (alignment: .center) {
                        Image("no_event")
                        Spacer()
                            .frame(height: 16)
                        Text("Введите код форума")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 18
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                            .frame(height: 12)
                        Text("Начните знакомство с остальными участниками прямо сейчас!")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 14
                                )
                            )
                            .foregroundStyle(textSecondary)
                        PinEntryView(pinLimit: 4, pinCode: $pinCode)
                            .onChange(of: pinCode, {
                                if (pinCode.count == 4) {
                                    isPresented = false
                                }
                            })
                    }
                    .padding([.vertical, .horizontal], 20)
                    .padding([.top], 16)
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .cornerRadius(16)
                }
                .padding()
                .transition(.moveAndFadeFromBottom)
                .zIndex(2)
                .onTapGesture {}
            }
        }
        .ignoresSafeArea()
        .environment(\.sizeCategory, .medium)
        .onAppear {
            show()
        }
        .onTapGesture {
            dismiss()
        }
    }

    func dismiss() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            } completion: {
                isPresented = false
            }
        } else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                isPresented = false
            }
        }
    }

    func show() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isAnimating = true
        }
    }
}

extension CustomAlertView where T == Never {

    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        actionTextKey: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) where T == Never {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented

        self.data = nil
        self.action = action
        self.message = message
        self.actionWithValue = nil
        self.messageWithValue = nil
    }
}

extension ForumCodeView where T == Never {

    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        _ pinCode: Binding<String>,
        actionTextKey: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) where T == Never {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented
        _pinCode = pinCode

        self.data = nil
        self.action = action
        self.message = message
        self.actionWithValue = nil
        self.messageWithValue = nil
    }
}

extension AnyTransition {
    static var moveAndFadeFromBottom: AnyTransition {
        AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
    }
}
