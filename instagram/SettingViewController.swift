//
//  SettingViewController.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/05.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
//isEmptyは入力された文字が空文字だけで会った際に実行される。
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges{ error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        self.view.endEditing(true)
    }
    @IBAction func handleLogoutButton(_ sender: Any) {
        //ログアウトする
        try!Auth.auth().signOut()
        //ログイン画面を表示する
        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(LoginViewController!, animated: true, completion: nil)
        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        tabBarController?.selectedIndex = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //viewWillAppearは何度も実行可能
        super.viewWillAppear(animated)
        //表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
        
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
