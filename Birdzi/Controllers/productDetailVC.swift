//
//  productDetailVC.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/26/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit

class productDetailVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    var titleTxt: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = self.titleTxt;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 @IBAction func btnClick(sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
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
