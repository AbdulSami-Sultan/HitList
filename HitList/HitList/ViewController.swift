//
//  ViewController.swift
//  HitList
//
//  Created by Abdul Sami Sultan on 27/08/2020.
//  Copyright © 2020 Sami. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people : [NSManagedObject] = []
    var names : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do{
            people = try managedContext.fetch(fetchRequest)
            print(people.count)
        }catch let error as NSError{
             print("Could not save.\(error), \(error.userInfo)")
        }
        
        
    }

    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
       
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else{
                    return
            }
            
            self.save(name: nameToSave)
            print(nameToSave)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true)
    }
    func save(name: String){
        guard let appDeleagte = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let manageContext = appDeleagte.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: manageContext)!
        let person = NSManagedObject(entity: entity, insertInto: manageContext)
        
        person.setValue(name, forKey: "name")
        do{
            try manageContext.save()
            people.append(person)
        }catch let error as NSError{
            print("Could not save.\(error), \(error.userInfo)")
        }
        
    }
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
    
    
}
