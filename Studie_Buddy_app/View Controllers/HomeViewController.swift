//
//  HomeViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit

class homeviewcontroller: UIViewController {

    
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
    super.viewDidLoad()
        
        self.navigationController!.navigationBar.largeContentTitle = NSLocalizedString("home", comment: "")
    self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.view.backgroundColor = .clear
        
        self.TableView.dataSource = self as? UITableViewDataSource
        self.TableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
            // Do any additional setup after loading the view.
            
           /* Alamofire.request("https://inhollandbackend.azurewebsites.net/api/test")
                .responseData { (response) in
                    let jsonData = response.data!

            let decoder = JSONDecoder()
            let testObjectsFromBackend = try? decoder.decode([TestObject].self, from: jsonData)
                    for item in testObjectsFromBackend!{
                        MyObjects.append(item)
                        print(MyObjects[0].description)
                    }
                    
                    self.tableView.reloadData()
            
            }
 */
        }
}

    extension homeviewcontroller: UITableViewDataSource{
        func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5 //MyObjects.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell",
            for: indexPath) as! HomeTableViewCell
            //cell.Label.text = MyObjects[indexPath.row].description
                        return cell
        }
}

 

