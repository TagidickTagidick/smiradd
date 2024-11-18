import SwiftUI
import NukeUI
import CoreImage.CIFilterBuiltins

struct QRCodePageView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @State private var template: TemplateModel?
    
    let id: String
    let bcTemplateType: String?
    let jobTitle: String
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(
        from string: String
    ) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            if self.template == nil {
                Spacer()
                    .background(.black)
                    .frame(
                        width: UIScreen.main.bounds.size.width,
                        height: UIScreen.main.bounds.size.height
                    )
            }
            else {
                LazyImage(
                    url: URL(
                        string: self.template!.picture_url!.replacingOccurrences(
                            of: "\\",
                            with: ""
                        )
                    )
                ) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .frame(
                                width: UIScreen.main.bounds.size.width,
                                height: UIScreen.main.bounds.size.height - 50
                            )
                            .clipped()
                    } else {
                        Color.gray.opacity(0.2)
                    }
                }
            }
            VStack (alignment: .leading) {
                Spacer()
                    .frame(
                        height: 10
                    )
//                Spacer()
//                    .frame(
//                        height: self.safeAreaInsets.top
//                    )
                BackButtonView()
                Spacer()
                VStack {
                    Spacer()
                        .frame(height: 12)
                    Image(
                        uiImage: generateQRCode(
                            from: "https://smiradd.ru/cards/\(self.id)"
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
                    Text(self.jobTitle)
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
        .onAppear {
            if self.bcTemplateType != nil {
                template = self.commonViewModel.templates.first(
                    where: { $0.id == self.bcTemplateType }
                ) ?? nil
            }
        }
    }
}
