import SwiftUI

extension View {

    /// Presents an alert with a message when a given condition is true, using a localized string key for a title.
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to present the alert.
    ///   - actionText: The key for the localized string that describes the text of alert's action button.
    ///   - action: Returning the alert’s actions.
    ///   - message: A ViewBuilder returning the message for the alert.
    func customAlert<M>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        actionText: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) -> some View where M: View {
        fullScreenCover(isPresented: isPresented) {
            CustomAlertView(
                titleKey,
                isPresented,
                actionTextKey: actionText,
                action: action,
                message: message
            )
            .presentationBackground(.clear)
        }
        .transaction { transaction in
            if isPresented.wrappedValue {
                // disable the default FullScreenCover animation
                transaction.disablesAnimations = true

                // add custom animation for presenting and dismissing the FullScreenCover
                transaction.animation = .linear(duration: 0.1)
            }
        }
    }
    
    func forumCode<M>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        pinCode: Binding<String>,
        actionText: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) -> some View where M: View {
        fullScreenCover(isPresented: isPresented) {
            ForumCodeView(
                titleKey,
                isPresented,
                pinCode,
                actionTextKey: actionText,
                action: action,
                message: message
            )
            .presentationBackground(.clear)
        }
        .transaction { transaction in
            if isPresented.wrappedValue {
                // disable the default FullScreenCover animation
                transaction.disablesAnimations = true

                // add custom animation for presenting and dismissing the FullScreenCover
                transaction.animation = .linear(duration: 0.1)
            }
        }
    }
}
