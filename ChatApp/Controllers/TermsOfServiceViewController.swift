//
//  TermsOfServiceViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/30.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    var reportBool = Bool()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "利用規約"
        contentTextView.text = "利用規約は「簡単チャット」をご利用いただく上で提供するサービスについての利用条件を定めるものです。また、当サービスをご利用いただく方(以下「ユーザー」といいます。)は利用規約の内容を承諾していただいたものとしてみなします。\n第一条(概要)\n当サービスは、各種インターネット情報サービスを提供いたします。\n当サービスのご利用に関しては料金は発生致しません。\n第二条(ユーザー)\n当サービスは無料となっておりますが、通信量・各種パケット通信代はユーザーが負担するものとします。当サービスは未成年者の利用、及び公序良俗に反する目的での利用を認めません。\n第三条(禁止事項)\n当サービスでは「インターネット異性紹介事業を利用して児童を誘引する行為の規制等に関する法律」に基づき、公序良俗に反するプロフィール及び(及びコンタクト内容)については、削除する場合があります。当サービスの利用にあたり、公序良俗に反するメッセージの送信を禁止します。\nプロフィール(及びメッセージ内容)の削除にあたるもの\n・犯罪行為の内容が含まれるもの\n・誹謗中傷が含まれるもの\n個人情報が含まれるもの\nHP宣伝、商業的宣伝が含まれるもの\n・異性との出会いや交際を目的とする内容が含まれるもの\n過度に暴力的な表現、露骨な性的表現、人権、国籍、信条、性別、社会的身分、門地等による差別につながる表現、自殺、自傷行為、拓物乱用を誘引または助長する表現、その他反社会的な内容を含み他人に不快感を与えるもの"

    }
    @IBAction func agreeButton(_ sender: Any) {
        reportBool = true
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = TabBarViewController()
        nextVC.reportBool = self.reportBool
    }
    
    
}
