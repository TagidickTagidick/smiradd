import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodePageView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var cardSettings: CardViewModel
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var template: TemplateModel?
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        ZStack {
            if template != nil {
                AsyncImage(
                    url: URL(
                        string: template!.picture_url!.replacingOccurrences(of: "\\", with: "")
                    )
                ) { image in
                    image
                        .resizable()
                        .frame(
                            minWidth: UIScreen.main.bounds.size.width,
                            minHeight: UIScreen.main.bounds.size.height
                        )
                } placeholder: {
                    ProgressView()
                }
            }
            VStack (alignment: .leading) {
                Spacer()
                    .frame(height: safeAreaInsets.top)
                BackButton()
                Spacer()
                VStack {
                    Spacer()
                        .frame(height: 12)
                    Image(
                        uiImage: generateQRCode(
                            from: "smiradd://vizme.pro?id=\(cardSettings.cardModel.id)"
                        )
                    )
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 299,
                            height: 299
                        )
                    Spacer()
                        .frame(height: 4)
                    Text(cardSettings.cardModel.job_title)
                        .font(
                            .custom(
                                "OpenSans-Bold",
                                size: 22
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                        .frame(height: 29)
                }
                .padding(
                    [.horizontal],
                    7
                )
                .background(.white)
                .cornerRadius(24)
                Spacer()
            }
            .padding(
                [.horizontal],
                20
            )
        }
        .ignoresSafeArea()
        .frame(
            minWidth: UIScreen.main.bounds.size.width,
            minHeight: UIScreen.main.bounds.size.height
        )
        .onAppear {
            if cardSettings.cardModel.bc_template_type != nil {
                template = self.viewModel.templates.first(
                    where: { $0.id == cardSettings.cardModel.bc_template_type }
                ) ?? nil
            }
        }
    }
}
