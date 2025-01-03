import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var video: URL?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            if url.pathExtension.lowercased() == "gif" {
                if (try? Data(contentsOf: url)) != nil {
                    parent.video = url
                    parent.image = nil
                }
            }
            else {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    parent.image = image
                    parent.video = nil
                }
            }
        }
    }
}

