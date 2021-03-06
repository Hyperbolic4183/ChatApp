//
//  ContactViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/07/01.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        protocolLabel.layer.cornerRadius = 5
        protocolLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        protocolLabel.layer.shadowColor = UIColor.black.cgColor
        protocolLabel.layer.shadowOpacity = 0.6
        protocolLabel.layer.shadowRadius = 4
        
        protocolTextView.layer.cornerRadius = 5
        protocolTextView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        protocolTextView.layer.shadowColor = UIColor.black.cgColor
        protocolTextView.layer.shadowOpacity = 0.6
        protocolTextView.layer.shadowRadius = 4
        
        protocolTextView.text = "利用規約は「簡単チャット」をご利用いただく上で提供するサービスについての利用条件を定めるものです。また、当サービスをご利用いただく方(以下「ユーザー」といいます。)は利用規約の内容を承諾していただいたものとしてみなします。\n\n第一条(概要)\n当サービスは、各種インターネット情報サービスを提供いたします。\n当サービスのご利用に関しては料金は発生致しません。\n\n第二条(ユーザー)\n当サービスは無料となっておりますが、通信量・各種パケット通信代はユーザーが負担するものとします。当サービスは未成年者の利用、及び公序良俗に反する目的での利用を認めません。\n\n第三条(禁止事項)\n当サービスでは「インターネット異性紹介事業を利用して児童を誘引する行為の規制等に関する法律」に基づき、公序良俗に反するプロフィール及び(及びコンタクト内容)については、削除する場合があります。当サービスの利用にあたり、公序良俗に反するメッセージの送信を禁止します。\nプロフィール(及びメッセージ内容)の削除にあたるもの\n・犯罪行為の内容が含まれるもの\n・誹謗中傷が含まれるもの\n・個人情報が含まれるもの\n・異性との出会いや交際を目的とする内容が含まれるもの\n・過度に暴力的な表現、露骨な性的表現、人権、国籍、信条、性別、社会的身分、門地等による差別につながる表現、自殺、自傷行為、乱用を誘引または助長する表現、その他反社会的な内容を含み他人に不快感を与えるもの\n・他のユーザーに対する嫌がらせや誹謗中傷を目的とする行為\n\n第四条(罰則)\nユーザーからの通報により、第三条で示した禁止事項に反する内容が確認された場合、サービスの停止・アカウントの削除の措置を講じます。\n\n第五条(メッセージ内容の情報と取扱について)\n送信したメッセージ内容は当サービスのクラウド上へアップロードされます。アップロードされた情報は当サービス以外の目的に利用することはありません。\n\n第六条(利用規約の変更)\n当サービスは利用規約を随時変更することができるものとします。当サービスはサービスの内容を了承なく変更できるものとします。\n\n第七条(開発者の免責)\n開発者は、開発者の故意または重過失に起因する場合を除き、当サービスに起因してユーザに生じたあらゆる損害について一切の責任を負いません。\n\n第六条\nこのアプリについて開発者へ直接連絡を行いたい場合はTwitterアカウントHyperbolic____より連絡をお寄せください。"
        
    }
    
    @IBOutlet weak var protocolLabel: UILabel!
    @IBOutlet weak var protocolTextView: UITextView!
    
    
    
}
