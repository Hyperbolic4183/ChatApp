//
//  JoinedRoomViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/25.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift
class JoinedRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var test5 = try! Realm().objects(RoomName.self)

    @IBOutlet weak var roomTableView: UITableView!
    var reportBool = false
    var userDefaults = UserDefaults.standard
    var joinedRoomName: [String?] = []
    var joinedRoomPassword: [String?] = []
    var password = ""
    let cellSpacingHeight: CGFloat = 5
    
    let test = RoomMakeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()//追加
        print(test5.count)
        
        overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 129/255, blue: 124/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        roomTableView.delegate = self
        roomTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        var test6 = userDefaults.integer(forKey: "usernumber")
        print("usernumberは\(test6)です")
        print(test5.count)
  //      print(test5[0].roomName)
       // print(userDefaults.integer(forKey: "userid"))
        super.viewWillAppear(animated)
        
        joinedRoomName = (userDefaults.array(forKey: "name") ?? []) as [String]
        
        joinedRoomPassword = (userDefaults.array(forKey: "password") ?? []) as [String]
       if Auth.auth().currentUser == nil {
           print("ログインしていない")
        
        performSegue(withIdentifier: "ban", sender: nil)
        
       } else {
           print("ログインしていてidは\(Auth.auth().currentUser?.uid)")
        
        
       }
        
        roomTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.joinedRoomName.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.roomTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        // note that indexPath.section is used rather than indexPath.row
        cell.textLabel?.text = self.test5[indexPath.section].roomName//self.joinedRoomName[indexPath.section]
        
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowRadius = 4
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "cellSegue", sender: nil)
        
    }
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSegue" {

        let indexPath = self.roomTableView.indexPathForSelectedRow
        let NextVC = segue.destination as! ChatViewController
        NextVC.roomName = self.joinedRoomName[indexPath!.section]!
        NextVC.roomPassword = self.joinedRoomPassword[indexPath!.section]!
        NextVC.password = "\(joinedRoomName[indexPath!.section]!)\(joinedRoomPassword[indexPath!.section]!)"
        } 
        
    }
    
    
    


}
