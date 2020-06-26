//
//  JoinedRoomViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/25.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class JoinedRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var roomTableView: UITableView!
    var userDefaults = UserDefaults.standard
    var joinedRoomName: [String?] = []
    var joinedRoomPassword: [String?] = []
    var password = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        roomTableView.delegate = self
        roomTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        
        joinedRoomName = (userDefaults.array(forKey: "name") ?? [""]) as [String]
        
        joinedRoomPassword = (userDefaults.array(forKey: "password") ?? []) as [String]
        
        if joinedRoomName.count == 0 {
        print("joinedRoomNameは\(joinedRoomName.count - 1)")
        } else {
            print("joinedRoomNameは\(joinedRoomName.count)")
            
        }
        if joinedRoomName.count == 0 {
        print("joinedRoomNameは\(joinedRoomPassword.count - 1)")
        } else {
            print("joinedRoomPasswordは\(joinedRoomPassword.count)")
        }
        
        roomTableView.reloadData()
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinedRoomName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = joinedRoomName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "cellSegue", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.roomTableView.indexPathForSelectedRow
        let NextVC = segue.destination as! ChatViewController
        NextVC.roomName = self.joinedRoomName[indexPath!.row]!
        NextVC.roomPassword = self.joinedRoomPassword[indexPath!.row]!
        NextVC.password = "\(joinedRoomName[indexPath!.row]!)\(joinedRoomPassword[indexPath!.row]!)"
    }


}
