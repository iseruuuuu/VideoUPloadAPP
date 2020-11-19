//
//  ViewController.swift
//  VideoUPloadAPP
//
//  Created by user on 2020/11/19.
//

import UIKit
import Photos
import AVKit

class VideoUploaderViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    private var videoUrl: NSURL?
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBAction func didTapSelectButton(_ sender: Any) {
        selectVideo()
        self.imagePickerController.delegate = self
    }
    
    
    private let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmPhotoLibraryAuthenticationStatus()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func confirmPhotoLibraryAuthentication() {
    }
    
    func confirmPhotoLibraryAuthenticationStatus() {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            //許可(authorized)されていない・ここで初回のアラートが出る
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                //もし状態(status)が、初回(notDetermined)もしくは拒否されている(denied)の場合
                case .notDetermined, .denied:
                    //許可しなおして欲しいので、設定アプリへの導線をおく
                    self.appearChangeStatusAlert()
                default:
                    break
                }
            }
        }
    }
    
    
    
    private func appearChangeStatusAlert() {
        //フォトライブラリへのアクセスを許可していないユーザーに対して設定のし直しを促す。
        //タイトルとメッセージを設定しアラートモーダルを作成する
        let alert = UIAlertController(title: "Not authorized", message: "we need to access photo library to upload video", preferredStyle: .alert)
        //アラートには設定アプリを起動するアクションとキャンセルアクションを設置
        let settingAction = UIAlertAction(title: "setting", style: .default, handler: { (_) in
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
        })
        let closeAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        //アラートに上記の２つのアクションを追加
        alert.addAction(settingAction)
        alert.addAction(closeAction)
        //アラートを表示させる
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectVideo() {
        self.imagePickerController.mediaTypes = ["public.movie"]
        self.imagePickerController.sourceType = .photoLibrary
        //実際にimagePickerControllerを呼び出してフォトライブラリを開く
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let key = UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL")
        videoUrl = info[key] as? NSURL
        
        thumbnailImageView.image =  generateThumbnailFromVideo((videoUrl?.absoluteURL)!)
        thumbnailImageView.contentMode = .scaleAspectFit
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func generateThumbnailFromVideo(_ url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
    
    
    
    
    
    
    
}







