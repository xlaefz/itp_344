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
        "https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg", "http://img2.tvtome.com/i/u/28c79aac89f44f2dcf865ab8c03a4201.png", "http://news.brown.edu/files/article_images/MarsRover1.jpg", "https://loveoffriends.files.wordpress.com/2012/02/love-of-friends-117.jpg", "http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg", "http://www.facultyfocus.com/wp-content/uploads/images/iStock_000012443270Large150921.jpg", "http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",  "http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",  "http://www.ymcanyc.org/i/ADULTS%20groupspinning2%20FC.jpg",  "http://www.dogslovewagtime.com/wp-content/uploads/2015/07/Dog-Pictures.jpg",  "http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"
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
//                    self.tableData.append(image!)
                    
                    let CIimage: CIImage = CIImage(data: try! Data(contentsOf: URL(string: imageUrl)!))!
                    let context = CIContext(options:nil)
                    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
                    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
                    let faces = faceDetector?.features(in: CIimage)
                    self.faceCount = (faces?.count)!
                    
                    let hueAdjust : CIFilter! = CIFilter(name: "CIHueAdjust")
                    hueAdjust.setDefaults()
                    hueAdjust.setValue(CIimage, forKey: kCIInputImageKey)
                    hueAdjust.setValue(2.094, forKey: kCIInputAngleKey)
                    let hueImage = hueAdjust.outputImage
                    
                    let exposureAdjust: CIFilter! = CIFilter(name: "CIExposureAdjust")
                    exposureAdjust.setValue(hueImage, forKey: kCIInputImageKey)
                    exposureAdjust.setValue(0.3, forKey: kCIInputEVKey)
                    let doubleModdedFilter = exposureAdjust.outputImage
                    

                    let blurFilter : CIFilter!  = CIFilter(name: "CIGaussianBlur")
                    blurFilter.setValue(CIimage, forKey: kCIInputImageKey)
                    blurFilter.setValue(5.0, forKey: kCIInputRadiusKey)
                    let blurImage = blurFilter.outputImage
                    var newImage:UIImage?
                    
                    if(self.faceCount == 0){
                        newImage = UIImage(ciImage: doubleModdedFilter!)
                    }else{
                        newImage = UIImage(ciImage: blurImage!)
                    }
                    self.tableData.append(newImage!)

                    
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
    var faceCount = 0;
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
		if(cell == nil){
			cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
		}
		
		cell?.imageView?.image = tableData[indexPath.row]
        if(faceCount == 0){
            cell?.textLabel?.text = "No Faces Detected"
        }
        else{
            cell?.textLabel?.text = String(faceCount) + " face(s) detected"
        }
		return cell!
	}
	
	
	


}

