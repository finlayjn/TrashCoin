//
//  ProfileVC.swift
//  TrashCoin
//
//  Created by Finlay Nathan on 10/26/19.
//  Copyright © 2019 Finlay Nathan. All rights reserved.
//

import Foundation
import UIKit

class ProfileVC: UITableViewController {
    
    var array = [String]()
    
    override func viewDidLoad() {
        
        let imageCell = UINib(nibName: "ImageCell", bundle: nil)
        self.tableView.register(imageCell, forCellReuseIdentifier: "ImageCell")
        
        if let testArray = UserDefaults.standard.object(forKey: "images") as? [String] {
            self.array = testArray
        } else {
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Your Profile"
        } else if section == 1 {
            return "Your Trash"
        } else {
            return "Error"
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return array.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 80
        } else {
            return 110
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
            let imageName = UIImage(named: "ricardo")
            cell.imageView?.image = imageName
            cell.selectionStyle = .none
            if let testMoney = UserDefaults.standard.object(forKey: "money") as? Float {
                cell.detailTextLabel?.text = "TC$\(testMoney)"
                
            } else {
                cell.detailTextLabel?.text = "TC$0.00"
            }
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.trashImageView?.image = loadImageFromDiskWith(fileName: array[indexPath.row] )
            cell.labelView?.text = "Trash \(indexPath.row+1)"
            cell.selectionStyle = .none
            return cell
        }
                
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
    
}


