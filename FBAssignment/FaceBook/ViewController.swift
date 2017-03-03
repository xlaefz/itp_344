//
//  ViewController.swift
//  FaceBook
//
//  Created by Administrator on 10/3/16.
//  Copyright © 2016 ITP344. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit



class ViewController: UIViewController, FBSDKLoginButtonDelegate {

	@IBOutlet weak var viewFriendsButton: UIButton!
	var loginButton : FBSDKLoginButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loginButton = FBSDKLoginButton()
		loginButton.center = self.view.center
		self.view.addSubview(loginButton)
		
		loginButton.delegate = self
		
		print("Logged in")
		let likeButton : FBSDKLikeButton = FBSDKLikeButton()
		likeButton.center = self.view.center
		likeButton.center.y += 150
		likeButton.objectID = "https://www.facebook.com/FacebookDevelopers"
		
		self.view.addSubview(likeButton)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if(FBSDKAccessToken.current() == nil){
			self.performSegue(withIdentifier: "loginSegue", sender: self)
			return
		}

		
	}
	
	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
	
		loginButton.readPermissions = ["public_profile", "email", "user_friends"]
		print("loginButton didCompleteWith \(error)")
		
	}
	
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		
		self.performSegue(withIdentifier: "loginSegue", sender: self)
		
	}


	@IBAction func shareOnFBTouched(_ sender: AnyObject) {
		
		let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
		content.contentURL = URL(string: "http://www.google.com")
		FBSDKShareDialog.show(from: self, with: content, delegate: nil)
		
	}
	


}

