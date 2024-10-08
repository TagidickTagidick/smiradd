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
        isRed: Bool = false,
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
        .transaction {
            transaction in
            transaction.disablesAnimations = true
        }
    }
    
    func networkingAlert<M>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        actionText: LocalizedStringKey,
        image: String,
        title: String,
        description: String,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) -> some View where M: View {
        fullScreenCover(isPresented: isPresented) {
            NetworkingAlertView(
                titleKey,
                isPresented,
                actionTextKey: actionText,
                image: image,
                title: title,
                description: description,
                action: action,
                message: message
            )
            .presentationBackground(.clear)
        }
        .transaction {
            transaction in
            transaction.disablesAnimations = true
        }
    }
}
