//
//  TabBarController.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/05.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import  Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87,alpha: 1)
        //UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
//タブバーが表示される時に行う処理を記述
        super.viewDidAppear(animated)
//currentUserがnilのとき、ログインしていないことを表す。
        if Auth.auth().currentUser == nil{
            let loginViewController = self.storyboard?.instantiateViewController(identifier: "Login")
//instantiateViewControllerメソッドで該当のViewControllerを取得することができる
            self.present(loginViewController!, animated: true, completion: nil)
//presentでモーダル遷移
        }
        
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //optional func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) ->Boolのメソッドはタブボタンがタップされた時に呼ばれ、returnでtrueまたはfalse(Bool型)を返す事によりタブの切り替えを行うか否かを決定させる。また、その中に新しく式を入れても良い。また第二引数のviewControllerは遷移先のviewControllerのインスタンスが入る
        if viewController is ImageSelectViewController {
            let imageSelectViewController = storyboard!.instantiateViewController(identifier: "ImageSelect")
//instantiateViewControllerメソッドを使う事により、storyboardに定義されているImageSelectViewControllerを読み込み、presentメソッドでモーダル遷移を行う。
            present(imageSelectViewController, animated: true)
            
            return false
            //タブが選択された際にタブ切り替えが行われないのがfalse
        }else{
            return true
        }
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
