//
//  FirstViewController.swift
//  TextView
//
//  Created by Chuang Boris on 29/10/2017.
//  Copyright © 2017 Bchuang. All rights reserved.
//

import UIKit

//MARK: - UITextViewDelegate

extension FirstViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = firstTextViewPlaceHolder
//            textView.textColor = UIColor.lightGray
//        }
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Set validation rule
        return true
    }
}
    
class FirstViewController: UIViewController {

    @IBOutlet weak var FirstTextView: UITextView!
    let firstTextViewPlaceHolder = "Please fill something..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - func
    
    func initView() {
        FirstTextView.text = firstTextViewPlaceHolder
        FirstTextView.textColor = UIColor.lightGray
        FirstTextView.delegate = self
    }
}

