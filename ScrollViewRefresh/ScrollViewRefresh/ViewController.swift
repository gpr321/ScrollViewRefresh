//
//  ViewController.swift
//  ScrollViewRefresh
//
//  Created by mac on 15/3/11.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.tableView.addHeaderRefresh()
        self.tableView.addFooterRefresh()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.text = "haha"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0{
            tableView.endHeaderRefresh()
//            tableView.beginHeaderRefreshing()
        } else {
//            tableView.endFooterRefresh()
            tableView.beginFooterRefreshing()
        }
    }
    

}

