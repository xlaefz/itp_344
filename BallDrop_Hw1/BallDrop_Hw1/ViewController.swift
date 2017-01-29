//
//  ViewController.swift
//  BallDrop_Hw1
//
//  Created by Jason Zheng on 1/29/17.
//  Copyright © 2017 Jason Zheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    
    var animator:UIDynamicAnimator!
   
    var gravity = UIGravityBehavior()
    let screenSize: CGRect = UIScreen.main.bounds
    var collision = UICollisionBehavior()
    var itemBehavior = UIDynamicItemBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        animator = UIDynamicAnimator(referenceView: self.view)
        
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)
        itemBehavior.elasticity = 0.6
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let ball = UIView(frame: CGRect(x:screenSize.width/2, y:0, width:50, height: 50))
        ball.backgroundColor = UIColor.red
        ball.layer.cornerRadius = 25;
        self.view.addSubview(ball)
        gravity.addItem(ball)
        collision.addItem(ball)
        itemBehavior.addItem(ball)
    }

}

