//
//  LoginViewController.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/05.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text,let password = passwordTextField.text {
            if address.isEmpty || password.isEmpty {
                return
            }
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                //クロージャー内の処理
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                //HUDを消す
                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }
            //クロージャー内の処理
        }
    }
    @IBAction func handleCreateAccountButtun(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text{
            //上のifいるのか？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
                //returnで処理をここで止める
            }
//HUDで処理中を表示
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: address, password: password) {
                authResult, error in
                
                
                if let error = error {
                    //クロージャーとは処理の塊であり、サーバー側からアカウント作成処理が完了した通知が届いた際にその中の引数が渡され、何かしら(エラー情報など)をその引数が受けっとてくる
                    //=の前のエラーはクロージャーが呼び出された時に返されるエラーは発生時にはエラーを受け取る引数
                    //authResultはクロージャーが呼び出された時に認証結果情報を受け取る引数
                    //error,authResult共に受け取っているので値はnilではない。
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    //error.localizedDescriptionによりエラーの内容をstringとして表示
                    return
                }
                
                
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                
                let user = Auth.auth().currentUser
//名前を変えたいためにuser情報を取得する
                if let user = user {
                    //この二行で何をしている？二行目のlet userとは？それともlet user = Auth.auth().currentUserを消してuser = userに置き換えてはいけないのか？
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
//HUDを消す
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
