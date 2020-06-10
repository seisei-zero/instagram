//
//  PostTableViewCell.swift
//  instagram
//
//  Created by 林正悟 on 2020/06/08.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //PostDataのオブジェクト(インスタンス)[postData]を引数で受け取り、その内容をセルに表示するsetPostData(_:)メソッド
    func setPostData(_ postData: PostData) {
        // 画像の表示/sd_imageIndicatorプロパティは、Cloud Storageから画像をダウンロードしている間、ダウンロード中であることを示すインジケーターを表示する指定
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//Cloud Storageの画像保存場所を取得
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
//sd_setImage(with:)メソッドの引数にCloud Storageの画像保存場所を指定するだけで自動的に指定場所から画像をダウンロードしてUIImageViewに表示
        postImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
//Dateクラスに入っている日時情報を DateFormatterで文字列に変換
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
//dateFormatプロパティに "yyyy-MM-dd HH:mm"と指定すると、 Dateクラスに格納されている日時情報は 2019-09-15 09:41 といった形の文字列に変換する
            let dateString = formatter.string(from: date)
//formatter.stringで文字を取り出す。
            self.dateLabel.text = dateString
        }
        
        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
    
}
