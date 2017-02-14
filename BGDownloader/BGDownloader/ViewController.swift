//
//  ViewController.swift
//  BGDownloader
//
//  Created by Administrator on 9/14/16.
//  Copyright © 2016 ITP. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	
	@IBOutlet weak var tableView: UITableView!
	
	let dataURLs : [String] = [
		"https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg",
		"http://www.wired.com/wp-content/uploads/images_blogs/wiredscience/2012/08/Mars-in-95-Rover1.jpg",
		"http://news.brown.edu/files/article_images/MarsRover1.jpg",
		"http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg",
		"https://upload.wikimedia.org/wikipedia/commons/f/fa/Martian_rover_Curiosity_using_ChemCam_Msl20111115_PIA14760_MSL_PIcture-3-br2.jpg",
		"http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",
		"http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",
		"http://www.nasa.gov/sites/default/files/thumbnails/image/journey_to_mars.jpeg",
		"http://i.space.com/images/i/000/021/072/original/mars-one-colony-2025.jpg?1375634917",
		"http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"
	]
	
	var tableData : [UIImage] = []
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	@IBAction func downloadTouched(_ sender: AnyObject) {
        
        let device = UIDevice.current
        if(!device.isMultitaskingSupported){
            print("Multitasking not supported on this device.")
        }

        
        
        DispatchQueue.global(qos: .background).async {
            var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
            bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(bTask)
                bTask = UIBackgroundTaskInvalid
                print("task ended")
            })
            
            for i in 0  ..< self.dataURLs.count{
                let backgroundTimerRemaining = UIApplication.shared.backgroundTimeRemaining
                print(backgroundTimerRemaining)
                if(backgroundTimerRemaining > 100){
                    let imageUrl = self.dataURLs[i]
                    let image = UIImage(data: try! Data(contentsOf: URL(string: imageUrl)!))
                    self.tableData.append(image!)
                    DispatchQueue.main.sync {
                        print("This is run on the main queue, after the previous code in outer block")
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
		
		cell?.imageView?.image = tableData[indexPath.row]
		cell?.textLabel?.text = dataURLs[indexPath.row]
		return cell!
	}
	
	
	


}

