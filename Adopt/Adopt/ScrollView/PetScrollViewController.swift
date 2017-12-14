//
//  PetScrollViewController.swift
//  Adopt
//
//  Created by Chuang Boris on 12/12/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import UIKit
import CoreData

class PetScrollViewController: UIViewController {
    
    //MARK: Constants
    let apiUrl = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c"
    
    //MARK: Variables
    var apiPets: [PetData]?
    var dbPets: [Pet]?
    var index: Int = 0
    var petCount: Int = 0
    
    //MARK: Outlets
    @IBOutlet weak var petImage: UIImageView!
    
    //MARK: BActions
    
    @IBAction func exit(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LoveButton(_ sender: UIButton) {
        saveLovePetToDB(selectedIndex: index)
        nextImage()
    }
    
    @IBAction func DropButton(_ sender: UIButton) {
        nextImage()
    }
    
    @IBAction func Swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.right:
            preImage()
            print("Swiped right")
        case UISwipeGestureRecognizerDirection.down:
            print("Swiped down")
        case UISwipeGestureRecognizerDirection.left:
            nextImage()
            print("Swiped left")
        case UISwipeGestureRecognizerDirection.up:
            print("Swiped up")
        default:
            break
        }
    }
    
    //MARK: Initial
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerSwipe()
        webFetchPets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func preImage() {
        if index > 0 {
            index -= 1
        } else if index == 0 {
            index = 0
        }
        //TODO animation for picture
        
        setImage()
    }
    
    func nextImage() {
        if index < petCount {
            index += 1
        } else if index == petCount {
            index = 0
        }
        //TODO animation for picture
        
        setImage()
    }
    
    func setImage() {
        if let item = dbPets?[index],let imageName = item.imagename, let url = URL(string: imageName) {
            fetchImage( url: url) { (image) in
                DispatchQueue.main.async {
                    self.petImage.image = image
                }
            }
        } else {
            self.petImage.image = UIImage(named: "NoImage")
        }
    }
    
    
}

//MARK: Swipe
extension PetScrollViewController {
    
    //MARK: Methods
    func registerSwipe() {
        AddGestureSwipe(driection: UISwipeGestureRecognizerDirection.left)
        AddGestureSwipe(driection: UISwipeGestureRecognizerDirection.right)
    }
    
    func AddGestureSwipe(driection: UISwipeGestureRecognizerDirection) {
        let swipe = UISwipeGestureRecognizer(
            target:self,
            action:#selector(PetScrollViewController.Swipe(_:)))
        swipe.direction = driection
        self.view.addGestureRecognizer(swipe)
    }
}


//extension PetScrollViewController: UIScrollViewDelegate {
//
//}

extension PetScrollViewController {
    
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
            if let count = dbPets?.count {
                petCount = count
            }
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
            self.setImage()
        }
    }
    
    func saveLovePetToDB(selectedIndex: Int) {
        var selectedPet = dbPets?[selectedIndex]
        DispatchQueue.main.async {
            if let item = selectedPet {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let pet = LovePet(context: context)
                
                pet.acceptnum = item.acceptnum
                pet.age = item.age
                pet.build = item.build
                pet.email = item.email
                pet.hairtype = item.hairtype
                pet.id = item.id
                pet.imagename = item.imagename
                pet.name = item.name
                pet.note = item.note
                pet.phone = item.phone
                pet.resettlement = item.resettlement
                pet.sex = item.sex
                pet.type = item.type
                pet.variety = item.variety
                
                appDelegate.saveContext()
            }
        }
    }
}




