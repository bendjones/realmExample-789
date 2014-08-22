//
//  ViewController.swift
//  RealmExample
//
//  Created by Ben Jones on 8/22/14.
//  Copyright (c) 2014 Avocado Software Inc. All rights reserved.
//

import UIKit
import Realm

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView?
    var examples: RLMArray?
    var notificationToken: RLMNotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib

        tableView = UITableView(frame: view.bounds)
        tableView!.delegate = self
        tableView!.dataSource = self
        view.addSubview(tableView!)
    }

    override func viewWillAppear(animated: Bool) {
        examples = ExampleObject.allObjects().arraySortedByProperty("createDate", ascending: true)

        tableView?.reloadData()

        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { (_ , _) in
            if let tableView = self.tableView {
                tableView.reloadData()
            }
        }
    }

    override func viewDidDisappear(animated: Bool) {
        if let token = notificationToken {
            RLMRealm.defaultRealm().removeNotification(token)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let array = examples {
            println("array count \(array.count)")
            return Int(array.count)
        }

        return 0
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let tableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "ViewControllerTableViewCell")

        if let example = examples?[UInt(indexPath.row)] as? ExampleObject {
            tableViewCell.textLabel.text = example.text
        }

        return tableViewCell
    }
}

