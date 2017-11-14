//
//  GuessNumberViewController.swift
//  Lesson6-Practice2
//
//  Created by Chuang Boris on 12/11/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import UIKit
import GameplayKit

class GuessNumberViewController: UIViewController {
    
    //MARK: Define
    @IBOutlet weak var LeftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var RightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var GuessNumberTextField: UITextField!
    @IBOutlet weak var GuessNumberLabel: UILabel!
    @IBOutlet weak var GuessNumberTableView: UITableView!

    var guessNumberSize = 4
    var randomGuessNumber = ""
    var guessNumberList: [GuessNumberInfo]?
    var isShowAnswer: Bool = false
    
    //MARK: Action - Button
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func NewGame(_ sender: Any) {
        newGame()
    }
    
    @IBAction func Submit(_ sender: Any) {
        //TODO append guessNumber
        if let guessNum = GuessNumberTextField.text, guessNum != "" && Array(guessNum).count == guessNumberSize {
            guessNumberList?.append(validateGuessNumber(number: guessNum))
        }
        GuessNumberTableView.reloadData()
    }
    
    //MARK: View - Initial
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        newGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        LeftBarButtonItem.title = "Back"
        RightBarButtonItem.title = "New Game"
        SubmitButton.setTitle("Submit", for: UIControlState.normal)
        GuessNumberLabel.text = "Guess Num："
        GuessNumberTextField.text = ""
        
        GuessNumberTableView.dataSource = self
        GuessNumberTableView.delegate = self
        GuessNumberTextField.delegate = self
    }
    
    //MARK: Func - Logic
    func newGame() {
        guessNumberList = [GuessNumberInfo]()
        let randomFeed = GKRandomDistribution(lowestValue: 1000, highestValue: 9999)
        randomGuessNumber = String(randomFeed.nextInt())
        GuessNumberTextField.text = ""
        GuessNumberTableView.reloadData()
        SubmitButton.isEnabled = false
    }
    
    func validateGuessNumber(number: String) -> GuessNumberInfo {
        let result = GuessNumberInfo()
        var currentPlaceValueCnt:Int = 0, wrongPlaceCnt:Int = 0, matchNumCnt: Int = 0
        for i in 0...(Array(number).count - 1) {
            if Array(number)[i] == Array(randomGuessNumber)[i] {
                currentPlaceValueCnt += 1
            }
            var isMatchNum = false
            for ii in 0...(Array(randomGuessNumber).count - 1) {
                if Array(number)[i] == Array(randomGuessNumber)[ii] {
                   isMatchNum = true
                }
            }
            if isMatchNum {
                matchNumCnt += 1
            }
        }
        wrongPlaceCnt = matchNumCnt - currentPlaceValueCnt
        result.guessNumber = number
        result.guessResult = "\(currentPlaceValueCnt)A\(wrongPlaceCnt)B"
        result.status = currentPlaceValueCnt == guessNumberSize
        return result
    }
}

// MARK: UITableView
extension GuessNumberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = guessNumberList {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guessNumberTableViewCell", for: indexPath) as! GuessNumberTableViewCell
        
        cell.GuessNumberLabel.text = guessNumberList?[indexPath.row].guessNumber
        cell.GuessResultLabel.text = guessNumberList?[indexPath.row].guessResult
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numberString = isShowAnswer ? "  Number:\(randomGuessNumber)" : ""
        if let list = guessNumberList {
            return "Count:\(list.count) \(numberString)"
        }
        return "Count:\(0) \(numberString) "
    }
}

// MARK: UITextField
extension GuessNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == GuessNumberTextField {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            if newLength == guessNumberSize {
                SubmitButton.isEnabled = true
            }
            else {
                SubmitButton.isEnabled = false
            }
            
            return newLength <= guessNumberSize // Bool
        }
        return true
    }
}
