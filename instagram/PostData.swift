//
//  PostData.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/08.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot){
        //Firestoreからデータを取得すると、QueryDocumentSnapshotクラスのデータが渡されてきます
        self.id = document.documentID
        //投稿を保存する際に作られたユニークなid
        let postDic = document.data()
        //ここからQueryDocumentSnapshotクラスのデータをPostDataのプロパティに格納していく
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        if let likes = postDic["likes"] as? [String]{
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断/self.likes.firstIndex(of: myid)は自身のidがいいね一覧に含まれていたらそれを返す
            if self.likes.firstIndex(of: myid) != nil {
                //自身がいいねしている事を認識する
                self.isLiked = true
            }
        }
    }
}
