//
//  ReportViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/30.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    
    var reportContectsArray = ["スパムである","ヌードまたは性的行為","ヘイトスピーチまたは差別的なシンボル","暴力または危険な団体","違法又は規制対象商品","いじめまたは嫌がらせ","知的財産権の侵害","自殺、自傷行為、摂食障害","詐欺・欺瞞","虚偽の情報"]
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var reportTableViewCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        reportTableView.delegate = self
        reportTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportContectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        cell.textLabel?.text = reportContectsArray[indexPath.row]
        return cell
    }

}
