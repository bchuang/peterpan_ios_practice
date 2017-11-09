//
//  ViewController.swift
//  Lesson5-Practice1
//
//  Created by Chuang Boris on 09/11/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    var randomDirection: direction?
    var isAfterSelectButtonLock = false
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    //MARK: IBAction
    
    @IBAction func selectButton(_ sender: UIButton) {
        let result = checkResult(selectValue: sender.tag)
        var resultString = result ? "O" : "X"
//        resultString += ", Answer:\(randomDirection?.)"
        resultLabel.text = resultString
        if isAfterSelectButtonLock {
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        upButton.isEnabled = false
        downButton.isEnabled = false
        }
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        startPlay()
        if isAfterSelectButtonLock {
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        upButton.isEnabled = true
        downButton.isEnabled = true
        }
    }
    
    //MARK: Initial Func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initView()
    }
    
    func viewDidAppear() {
        startPlay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        rightButton.tag = direction.right.rawValue
        leftButton.tag = direction.left.rawValue
        downButton.tag = direction.down.rawValue
        upButton.tag = direction.up.rawValue
    }
    
    func startPlay() {
        let directions =  [direction.up, direction.down, direction.left,direction.right]
        let randomSeed = GKRandomDistribution(lowestValue: 0, highestValue: directions.count-1)
        randomDirection = directions[randomSeed.nextInt()]
        resultLabel.text = ""
        
    }
    
    func checkResult(selectValue: Int) -> Bool {
        return randomDirection?.rawValue == selectValue
    }
}
