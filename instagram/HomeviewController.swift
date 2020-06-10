//
//  HomeviewController.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/05.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import Firebase

class HomeviewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // 投稿データを格納する配列を取得
    var postArray: [PostData] = []
    // Firestoreのデータ更新の監視を行うためのリスナー(listener)
    var listener: ListenerRegistration!
    var postData:PostData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルを登録する
//カスタムセルを登録するには、UINib(nibName:bundle)でxibファイルを読み込み、それをregister(_:forCellReuseIdentifier:)メソッドで登録します。
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
//カスタムセルを CellというIdentifierで登録
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
//Firestoreの postsフォルダに格納されているドキュメントを投稿日時の新しい順に取得することができます。
//postRefで取得できるドキュメントを addSnapshotListenerメソッドで監視(結果、ドキュメントが更新されたりするたびにクロージャー内の動作を延々と繰り返す)します。
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。/クロージャーの引数のdocumentにはquerySnapshot!.documentsと同じく、ドキュメント(QueryDocumentSnapshot)の一覧が配列の形で入っている
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
//多分、この(document: document)内の二つ目のdocumentにはドキュメント(QueryDocumentSnapshot)の一覧の内の一つ、つまりQueryDocumentSnapshotを代入されており、PostData(document: document)とする事でclass PostData内のinit(document: QueryDocumentSnapshot)でイニシャライズされインスタンスを形成している/その上、returnで返してpostArrayに代入する事をドキュメント(QueryDocumentSnapshot)の一覧の回数分繰り返す事で配列を作っている。
                        return postData
                    }
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            // ログイン未(またはログアウト済み)
            if listener != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        //setPostDataメソッドを呼び出してindexPathに対応するPostDataをセルに表示するようにする
        cell.setPostData(postArray[indexPath.row])
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for:.touchUpInside)
//addTarget(_:action:for:)メソッドが、青い線を引っ張ってActionを設定する代わりになる。第二引数(action:)の #selectorで指定したメソッドが呼び出すメソッドになる
        cell.commentButton.addTarget(self, action:#selector(handleButton2(_:forEvent:)), for:.touchUpInside)
        return cell
    }
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
//第二引数にはUIEvent型のタップイベントが格納されます。タップイベントの中には、ボタンをタップした時の画面上の座標位置などが格納されています。
        print("DEBUG_PRINT: likeボタンがタップされました。")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
//タッチされた情報の全てを得る
        let point = touch!.location(in: self.tableView)
//タッチされた情報の中でタッチした座標(TableView内の座標)を割り出します
        let indexPath = tableView.indexPathForRow(at: point)
//タッチした座標がtableView内のどのindexPath位置になるのかを取得します。
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked{
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            }else{
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
//実際にはここで上から受け継いだデータの更新を行なっている
            postRef.updateData(["likes": updateValue])
        }
    }
    @objc func handleButton2(_ sender: UIButton, forEvent event: UIEvent){
        //第二引数にはUIEvent型のタップイベントが格納されます。タップイベントの中には、ボタンをタップした時の画面上の座標位置などが格納されています。
                print("DEBUG_PRINT: commentボタンがタップされました。")
                // タップされたセルのインデックスを求める
                let touch = event.allTouches?.first
        //タッチされた情報の全てを得る
                let point = touch!.location(in: self.tableView)
        //タッチされた情報の中でタッチした座標(TableView内の座標)を割り出します
                let indexPath = tableView.indexPathForRow(at: point)
        //タッチした座標がtableView内のどのindexPath位置になるのかを取得します。
                // 配列からタップされたインデックスのデータを取り出す
            postData = postArray[indexPath!.row]
        self.performSegue(withIdentifier: "toComment", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let commentViewController:commentViewController = segue.destination as! commentViewController
        commentViewController.postData = postData
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
