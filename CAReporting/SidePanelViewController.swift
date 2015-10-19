//
//  SidePanelViewController.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit


protocol SidePanelViewControllerDelegate {
    func menuItemSelected(menuItem: MenuItem)
}

class SidePanelViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    var menuItems = MenuItem.allMenuItems()
    
    var delegate: SidePanelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension SidePanelViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMenuItem = menuItems[indexPath.row]
        print(selectedMenuItem.title)
        delegate?.menuItemSelected(selectedMenuItem)
    }
}

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as! MenuItemCell
        cell.configureMenuItem(menuItems[indexPath.row].title, image: menuItems[indexPath.row].image)
        return cell
    }
}