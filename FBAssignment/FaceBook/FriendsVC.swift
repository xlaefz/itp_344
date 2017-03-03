//
//  FriendsVC.swift
//  FaceBook
//
//  Created by Administrator on 10/5/16.
//  Copyright © 2016 ITP344. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FriendsVC: UIViewController {

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
                        let picture = data["url"]
                        print(name)
//                        print(pictureObj)
                        print(picture)
                        print()
                        
                        
                    }
//                    print(result!)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
