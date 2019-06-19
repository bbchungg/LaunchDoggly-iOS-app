//
//  ProjectTableView.swift
//  LaunchDoggly
//
//  Created by Brian Chung on 5/26/19.
//  Copyright © 2019 Bchung Dev. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ProjectTableDelegate {
    func projectSelected(projectName: String?)
}

class ProjectTableView: UITableViewController {
    
    var checkedProject : String?
    var delegate : ProjectTableDelegate?
    var flagList: FlagList!
    var selectedFlag = Flag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let flag1 = Flag()
//        flag1.text = "tesdfsd"
//        flagList.items.append(flag1)
//        print(flagList.items[0].isChecked)
//        apiCall()
    }
    
//    let ldApi = LaunchDarklyApiModel()
    let colorChange = UIColorFromRGB() //Custom calls to change colors from RGB format

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
            cell.textLabel?.text = flagList.items[indexPath.row].text
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
        let item = flagList.items[indexPath.row]
        
        if item.isChecked {
            print(selectedFlag)
            selectedFlag = item
        }
        
        configureCheckmark(for: cell, with: item)
        cell.tintColor = UIColor.red
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = flagList.items[indexPath.row]
            
            //MARK: -> the below logic will handle duplication of checkmarks as well as checkmark being checked off when selected on an item with existing checkmark
            
            if item != selectedFlag { // if the current flag is not the previously selected flag, do the below
                item.toggleChecked() // if item is blank, this will make isChecked = true
                selectedFlag.toggleChecked() // this changes the isChecked property for previously selected flag
            }
            configureCheckmark(for: cell, with: item)
        }
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.projectSelected(projectName: flagList.items[indexPath.row].text)
        
        //CATransaction to set completion action, which is to return back to previous VC
        CATransaction.begin()
        tableView.beginUpdates()
        
        CATransaction.setCompletionBlock {
         _ = self.navigationController?.popViewController(animated: true) // used for "show"
//            _ = self.dismiss(animated: true, completion: nil) // used due to present modally
        }
        
        for cellPath in tableView.indexPathsForVisibleRows!{ // logic to deselect every row but the one with the checkmark
            if cellPath == indexPath {
                continue
            }
            tableView.cellForRow(at: cellPath)?.accessoryType = .none
        }
       
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
        
        CATransaction.commit()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: Flag) {
        
        if item.isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}
