//
//  YourRecommendationsTableViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class YourRecommendationsTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var products : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TestMixpanel.enteredYourRecommendationsView()
        
        title = "R e c o m m e n d a t i o n s".uppercaseString     // This is too long.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        startToLoadFromParse()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func startToLoadFromParse(){
        let query = PFQuery(className: "Product")
        query.whereKey("postedBy", equalTo: PFUser.currentUser())
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
            println("loading something.........")
            println(objects.count)
            
            if((error) == nil){
                self.products.removeAllObjects()
                for object in objects {
                    let product = Product(parseObject: object as PFObject)
                    self.products.addObject(product)
                    println("add")
                }
                self.tableView.reloadData()
            }
            else {
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (products.count == 0){
            return 1
        }
        else {
            return products.count+1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (products.count == 0){
            return 44*2
        }
        else {
            if (indexPath.row < products.count) {
                return TrendingTableViewCell.cellHeight()
            }
            else {
                return LoadMoreDataTableViewCell.cellHeight()
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (products.count == 0){
            let cellIdentifier = "NoRecommendationsCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
            
            if cell != nil {
                // println("Cell exist")
            }
            else {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            }
            
            cell?.textLabel?.text = "No Recommendations Now"
            
            return cell!
            
        }
        else {
            if (indexPath.row < products.count) {
                let product = products[indexPath.row] as Product
                
                let cellIdentifier = "YourRecommendatinosCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TrendingTableViewCell
                
                if cell != nil {
                    // println("Cell exist")
                }
                else {
                    cell = TrendingTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                }
                
                cell?.selectionStyle = UITableViewCellSelectionStyle.None;
                
                cell?.setContentValue(product, object: product.parseObject)
                return cell!
            }
            else {
                let cellIdentifier = "LoadMoreDataCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? LoadMoreDataTableViewCell
                
                if cell != nil {
                    // println("Cell exist")
                }
                else {
                    cell = LoadMoreDataTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                }
                
                return cell!
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
