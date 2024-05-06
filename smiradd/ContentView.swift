import SwiftUI

struct ContentView: View {

        var body: some View {
            NavigationStack(path: $presentedNumbers) {
                List(1..<50) { i in
                    NavigationLink(value: i) {
                        Label("Row \(i)", systemImage: "\(i).circle")
                    }
                }
                .navigationDestination(for: Int.self) { i in
                    switch i {
                        case 1:
                            SplashScreen()
                        case 2:
                            AuthorizationScreen(isSignUp: false)
                        case 3:
                            AuthorizationScreen(isSignUp: true)
                        default:
                            VStack {
                                Text("Detail \(i)")

                                Button("Go to Next") {
                                    presentedNumbers.append(i + 1)
                                }
                            }
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                presentedNumbers.append(3)
            }
        }
}
