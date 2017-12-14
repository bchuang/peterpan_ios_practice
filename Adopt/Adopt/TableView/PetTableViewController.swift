//
//  ViewController.swift
//  Adopt
//
//  Created by Chuang Boris on 11/12/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PetTableViewController: UIViewController {
    
    //MARK: variables
    var apiPets: [PetData]?
    var dbPets: [Pet]?
    
    //MARK: constrants
    let apiUrl = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c"
    
    //MARK: outlets
    @IBOutlet weak var petTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        petTableView.delegate = self
        petTableView.dataSource = self
        
        webFetchPets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PetTableViewController {
    
    func loadPets() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request:NSFetchRequest<Pet> = Pet.fetchRequest()
        
        //request.predicate = NSPredicate(format: "singer == %@ AND star > %d", "戴貓妮", 1)
        request.predicate = NSPredicate(format: "type == %@", "貓")
//        let sortDescriptor = NSSortDescriptor(key: "star", ascending: false)
//                request.sortDescriptors = [sortDescriptor]

        do {
            dbPets = try context.fetch(request)
        }
        catch {
            print("error")
        }
    }
    
    func webFetchPets() {
        if let urlStr = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data,response,error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                DispatchQueue.main.async {
                    if let data = data, let result = try? decoder.decode(DataTaipei.self, from: data)
                    {
                        self.apiPets = result.result.results
                        self.saveToDB()
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func clearToDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request:NSFetchRequest<Pet> = Pet.fetchRequest()
        
        do {
            dbPets = try context.fetch(request)
            if let itemList = dbPets {
                for item in itemList {
                    context.delete(item)
                }
            }
        }
        catch {
            print("error")
        }
    }
    
    func saveToDB() {
        DispatchQueue.main.async {
            self.clearToDB()
            if let data = self.apiPets {
                for item in data {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let pet = Pet(context: context)
                    
                    pet.acceptnum = item.AcceptNum
                    pet.age = item.Age
                    pet.build = item.Build
                    pet.email = item.Email
                    pet.hairtype = item.HairType
                    pet.id = item._id
                    pet.imagename = item.ImageName
                    pet.name = item.Name
                    pet.note = item.Note
                    pet.phone = item.Phone
                    pet.resettlement = item.Resettlement
                    pet.sex = item.Sex
                    pet.type = item.Type
                    pet.variety = item.Variety
                    
                    appDelegate.saveContext()
                }
            }
            self.loadPets()
            self.petTableView.reloadData()
        }
    }
}

extension PetTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = dbPets {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemList = dbPets {
            return itemList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath) as! PetTableViewCell
        
        if let item = dbPets?[indexPath.row] {
            if let name = item.name {
                cell.petName.text = name
            }
            if let imageName = item.imagename, let url = URL(string: imageName){
                fetchImage( url: url) { (image) in
                    DispatchQueue.main.async {
                        if let currentIndexPath = self.petTableView.indexPath(for: cell),currentIndexPath == indexPath {
                            cell.petImage.image = image
                        }

                    }
                }
            }
        }
        
        return cell
    }
}
