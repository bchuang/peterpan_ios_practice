//
//  PetScrollViewController.swift
//  Adopt
//
//  Created by Chuang Boris on 12/12/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import UIKit

class PetScrollViewController: UIViewController {

    //MARK: Constants
    
    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var petImage: UIImageView!
    
    //MARK: BActions
    @IBAction func LoveButton(_ sender: UIButton) {
        
    }
    
    @IBAction func DropButton(_ sender: UIButton) {
        
    }
    
    @IBAction func SwipeAction(_ sender: UISwipeGestureRecognizer) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension PetScrollViewController: UIScrollViewDelegate {
    
}




