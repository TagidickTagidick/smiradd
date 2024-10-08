import SwiftUI
import AVFoundation
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.videoUrl = ""
            }
            else if let videoUrl = info[.mediaURL] as? URL {
//                encodeVideo(
//                    at: videoUrl,
//                    completionHandler: {
//                        url,_ in
//                        self.parent.videoUrl = url!.absoluteString
//                    }
//                )
//                if let fileData = try? Data(contentsOf: videoUrl) {
//                    NetworkService().uploadVideo(
//                        data: fileData
//                    ) {
//                        result in
//                            DispatchQueue.main.async {
//                                switch result {
//                                case .success(let response):
//                                    self.parent.videoUrl = response
//                                    self.parent.image = nil
//                                    break
//                                case .failure(let errorModel):
//                                    print("Signup failed: \(errorModel.message)")
//                                    //completion(.failure(errorModel))
//                                }
//                            }
//                        }
//                }
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
            let avAsset = AVURLAsset(url: videoURL, options: nil)
                
            let startDate = Date()
                
            //Create Export session
            guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
                completionHandler?(nil, nil)
                return
            }
                
            //Creating temp path to save the converted video
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
            let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")
                
            //Check if the file already exists then remove the previous file
            if FileManager.default.fileExists(atPath: filePath.path) {
                do {
                    try FileManager.default.removeItem(at: filePath)
                } catch {
                    completionHandler?(nil, error)
                }
            }
                
            exportSession.outputURL = filePath
            exportSession.outputFileType = AVFileType.heic
            exportSession.shouldOptimizeForNetworkUse = true
//            let start = CMTimeMakeWithSeconds(0.0, 0)
//            let range = CMTimeRangeMake(start, avAsset.duration)
//            exportSession.timeRange = range
                
            exportSession.exportAsynchronously(completionHandler: {() -> Void in
                switch exportSession.status {
                case .failed:
                    print(exportSession.error ?? "NO ERROR")
                    completionHandler?(nil, exportSession.error)
                case .cancelled:
                    print("Export canceled")
                    completionHandler?(nil, nil)
                case .completed:
                    //Video conversion finished
                    let endDate = Date()
                        
                    let time = endDate.timeIntervalSince(startDate)
                    print(time)
                    print("Successful!")
                    print(exportSession.outputURL ?? "NO OUTPUT URL")
                    completionHandler?(exportSession.outputURL, nil)
                        
                    default: break
                }
                    
            })
        }

        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController
        ) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var videoUrl: String
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(
        context: Context
    ) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.mediaTypes = ["public.image", "public.movie"]
        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {}
}
