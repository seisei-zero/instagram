//
//  PostViewController.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/05.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する/compressionQualityは圧縮率
        let imageData = image.jpegData(compressionQuality: 0.75)
        //firebase内の投稿データの保存場所の名前をConst.PostPath="image"と定義する
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
//postRef.documentID + ".jpg"により投稿データの documentIDを画像のファイル名に利用している/imageRefは、Storageに保存する画像の保存場所を定義しています。
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
//metadataは、画像を保存する際のファイル形式を表します。今回はJPEG画像ファイルを保存するので image/jpegを指定します
        metadata.contentType = "image/jpeg"
//putData(_:metadata:completion:)メソッドを使用して画像をStorageにアップロードする
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                //PostViewControllerは、 先頭画面(TabBarController) -> ImageSelectViewController -> UIImagePickerController -> CLImageEditor -> PostViewControllerとモーダル画面遷移して表示されたものであるため、投稿処理をキャンセルし、一気に先頭画面に戻る処理
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
// FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
//Firestoreのサーバー上の時計を使用して日時を保存する指定
            ] as [String : Any]
//setData(_:)メソッドを実行することでFirestoreにデータを保存する
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func handleCancelButton(_ sender: Any) {
        //現在の画面を閉じ、加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
