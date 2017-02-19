//
//  DetailsViewController.swift
//  W1_Movies
//
//  Created by Phuong Thao Tran on 2/19/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var imgUrl = ""
    var summary = ""
    var movieTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        // Do any additional setup after loading the view.
        posterImg.setImageWith(NSURL(string: imgUrl) as! URL)
        summaryLabel.text = summary
        summaryLabel.sizeToFit()
        titleLabel.text = movieTitle
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
