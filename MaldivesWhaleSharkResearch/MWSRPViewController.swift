//
//  MWSRPViewController.swift
//  MaldivesWhaleSharkResearch
//
//  Created by mac on 5/7/17.
//  Copyright © 2017 dooddevelopments. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MWSRPViewController: UIViewController {


    @IBOutlet weak var videoButton: UIButton!
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let videoString:String? = Bundle.main.path(forResource: "whalesharkvideo", ofType: ".mp4")
        
        if let url = videoString {
            
            let videoURL = NSURL(fileURLWithPath: url)
            
            self.player = AVPlayer(url: videoURL as URL)
            self.playerController.player = self.player
        }

    }
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        self.present(self.playerController, animated: true) { 
            self.playerController.player?.play()
        }
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
