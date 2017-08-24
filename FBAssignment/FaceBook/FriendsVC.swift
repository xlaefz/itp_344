//
//  FriendsVC.swift
//  FaceBook
//
//  Created by Administrator on 10/5/16.
//  Copyright © 2016 ITP344. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableData : [UIImage] = []
    var dataURLS : [String] = []
    var nameData : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

		if(FBSDKAccessToken.current().hasGranted("user_friends")){
			
			// perform graph request
		
            let graphRequest = FBSDKGraphRequest(graphPath: "/me/taggable_friends?limit=1000000" , parameters: nil)
            
            graphRequest?.start(completionHandler: 	{
                (connection, result, error) -> Void in
                
                if (error == nil){
                    let resultDict = result as! [String:Any]
                    let friends = resultDict["data"] as! [[String:Any]]
                    for friend in friends{
                        let name = friend["name"]
                        let pictureObj = friend["picture"] as! [String:Any]
                        let data = pictureObj["data"] as! [String:Any]
                        let imageURL = data["url"]
                        print(imageURL)
                        self.dataURLS.append(imageURL! as! String)
                        self.nameData.append(name! as! String)
                    }
//                    print(result!)
                    print(self.dataURLS.count)
                    
                    DispatchQueue.global(qos: .background).async {
                        var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
                        bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                            UIApplication.shared.endBackgroundTask(bTask)
                            bTask = UIBackgroundTaskInvalid
                        })
                        for i in 0  ..< self.dataURLS.count{
                            let backgroundTimerRemaining = UIApplication.shared.backgroundTimeRemaining
                            print(backgroundTimerRemaining)
                            if(backgroundTimerRemaining > 100){
                                let imageUrl = self.dataURLS[i]
                                let image = UIImage(data: try! Data(contentsOf: URL(string: imageUrl)!))
                                self.tableData.append(image!)
                                DispatchQueue.main.sync {
                                    let rowIndex = i; //your row index where you want to add cell
                                    let sectionIndex = 0;//your section index
                                    let iPath : IndexPath = IndexPath(row: rowIndex, section: sectionIndex)
                                    self.tableView.insertRows(at: [iPath], with: UITableViewRowAnimation.left)
                                }
                            }else{
                                print("no time")
                            }
                        }
                    }
                    
                    
                }
            })
            
		}else{
			print("user_freinds access not granted")
			
		}
		
	}
    
    
	@IBAction func closeButtonTouched(_ sender: AnyObject) {
		
		self.dismiss(animated: true, completion: nil)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    let cellId = "cellId1"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        print(tableData[indexPath.row])
        cell?.imageView?.image = tableData[indexPath.row]
        cell?.textLabel?.text = nameData[indexPath.row]
        return cell!
    }
}
