//
//  ImagePicker.swift
//  CorneaApp
//
//  Created by Yoshiyuki Kitaguchi on 2021/12/03.
//  https://tomato-develop.com/swiftui-how-to-use-camera-and-select-photos-from-library/
//
// movie acquision:
//https://hatsunem.hatenablog.com/entry/2018/12/04/004823
//https://off.tokyo/blog/how-to-access-info-plist/
//https://ichi.pro/swift-uiimagepickercontroller-250133769115456




import SwiftUI

struct Imagepicker : UIViewControllerRepresentable {
    @Binding var show:Bool
    @Binding var image:Data

    
    var sourceType:UIImagePickerController.SourceType
 
    func makeCoordinator() -> Imagepicker.Coodinator {
        
        return Imagepicker.Coordinator(parent: self)
    }
      
    func makeUIViewController(context: UIViewControllerRepresentableContext<Imagepicker>) -> UIImagePickerController {
        
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = context.coordinator
        
        //photo, movieモード選択
        //controller.mediaTypes = ["public.image", "public.movie"]
        controller.mediaTypes = ["public.image"]
        controller.cameraCaptureMode = .photo // Default media type .photo vs .video
        controller.videoQuality = .typeHigh
        controller.cameraFlashMode = .on
        controller.cameraDevice = .rear //or front
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<Imagepicker>) {
    }
    
    class Coodinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

        var parent : Imagepicker
        
        init(parent : Imagepicker){
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Check for the media type
            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {

                if mediaType  == "public.image" {
                    print("Image Selected")
                    
                    let image = info[.originalImage] as! UIImage
                    let data = image.pngData()
                    self.parent.image = data!
                    self.parent.show.toggle()

                    UIImageWriteToSavedPhotosAlbum(image, nil,nil,nil) //カメラロールに保存

                    let cgImage = image.cgImage //CGImageに変換
                    let cropped = cgImage!.cropToSquare()
                    //撮影した画像をresultHolderに格納する
                    let imageOrientation = getImageOrientation()
                    let rawImage = UIImage(cgImage: cropped).rotatedBy(orientation: imageOrientation)
                    setImage(progress: 0, cgImage: rawImage.cgImage!)
                }

                if mediaType == "public.movie" {
                    print("Video Selected")
                }
            }
    
            }
            


        
        
        //ResultHolderに格納
        public func setImage(progress: Int, cgImage: CGImage){
            ResultHolder.GetInstance().SetImage(index: progress, cgImage: cgImage)
        }
        
    }
}
