//
//  commentViewController.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/10.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class commentViewController: UIViewController,UITextFieldDelegate {
    let name = Auth.auth().currentUser?.displayName
    var postData:PostData?
    @IBOutlet weak var commentField: UITextField!
    @IBAction func enterComment(_ sender: Any) {
        if let commentFieldtext = commentField.text{
//もしcommentFieldに文字が入力されていたとしたら
            if commentFieldtext.isEmpty{
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                return
            }
            // 更新データを作成する
            var updateValue: FieldValue
            let comment = "\(name!):\(commentField.text!)"
//likesがユーザー名を配列型式で保存しているのと同様にコメント者名とコメント内容を配列の中に組み込もうと考えている。
            updateValue = FieldValue.arrayUnion([comment])
            //commentsに更新データを書き込む
                        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData!.id)
            //実際にはここで上から受け継いだデータの更新を行なっている
                        postRef.updateData(["comments": updateValue])
            
        }
        self.dismiss(animated: true, completion: nil)
    }
//HomeViewControllerからタップして指定されたpostDataを受け取る

    override func viewDidLoad() {
        super.viewDidLoad()
        commentField.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentField.resignFirstResponder()
        return true
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
