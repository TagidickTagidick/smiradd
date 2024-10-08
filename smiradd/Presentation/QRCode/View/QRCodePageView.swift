import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodePageView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var template: TemplateModel?
    
    let cardModel: CardModel
    
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
            if self.template != nil {
                AsyncImage(
                    url: URL(
                        string: self.template!.picture_url!.replacingOccurrences(of: "\\", with: "")
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
                    .frame(height: self.safeAreaInsets.top)
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.4))
                        .frame(
                            width: 48,
                            height: 48
                        )
                    Image(systemName: "arrow.left")
                        .foregroundColor(textDefault)
                }
                .onTapGesture {
                    self.commonViewModel.closeQRCode()
                }
                Spacer()
                VStack {
                    Spacer()
                        .frame(height: 12)
                    Image(
                        uiImage: generateQRCode(
                            from: "https://smiradd.ru/cards/\(self.cardModel.id)"
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
                    Text(self.cardModel.job_title)
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
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .frame(
            minWidth: UIScreen.main.bounds.size.width,
            minHeight: UIScreen.main.bounds.size.height
        )
        .onAppear {
            if self.cardModel.bc_template_type != nil {
                template = self.commonViewModel.templates.first(
                    where: { $0.id == self.cardModel.bc_template_type }
                ) ?? nil
            }
        }
    }
}
