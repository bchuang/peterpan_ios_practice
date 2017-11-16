//
//  ViewController.swift
//  Lesson8
//
//  Created by Chuang Boris on 16/11/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var arr = [1,2,3,4,5]
//    var dic =
//        [
//            ["id":"1","name":"ray"],
//            ["id":"2","name":"ben"],
//            ["id":"3","name":"ken"],
//        ]
    
    var testDatas = [testData]()
    
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var firstTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        firstTableView.delegate = self
        firstTableView.dataSource = self
        
        for i in 1...3 {
            let item = testData(id: String(i), name: "ray\(i)")
            testDatas.append(item)
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ("\(dic[indexPath.row]["id"] ?? ""):\(dic[indexPath.row]["name"] ?? "")")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //todo call otherView
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "secondSegue", sender: self)
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondSegue" {
            if let vc = segue.destination as? SecondViewController {
                if let row = selectedIndexPath?.row {
                    vc.data = dic[row]["name"]
                }
            }
        }
    }
}
