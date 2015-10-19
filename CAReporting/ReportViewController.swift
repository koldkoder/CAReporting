//
//  ReportViewController.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

enum ViewState{
    case Summary
    case Detail
}

enum DestinationType {
    case Ads
    case SCM
}

@objc protocol ReportViewControllerDelegate {
    optional func collapseSidePanels()
}

class ReportViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, SidePanelViewControllerDelegate{

    @IBOutlet weak var reportTableView: UITableView!
    
    var summaries: [Summary]?
    var details: [Detail]?
    var currentState: ViewState?
    var currentDestination: DestinationType?
    
    var delegate: ReportViewControllerDelegate?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.rowHeight = UITableViewAutomaticDimension
        reportTableView.estimatedRowHeight = 100
 
        if currentState != nil && currentDestination != nil {
            setNavTitle()
            loadData()
        }
        
    }
    
    func loadData() {
        switch currentState! {
        case ViewState.Summary:
            let endpointUrl = getSummaryEndpoint()
            CARClient.sharedInstance.getSummary(endpointUrl, completion: { (summaries, error) -> () in
                if (summaries != nil) {
                    self.summaries = summaries
                    self.reportTableView.reloadData()
                }
            })
            break
        case ViewState.Detail:
            self.details = []
            break
        }
        
    }
    
    func setNavTitle() {
        if currentDestination == nil {
            return
        }
        switch currentDestination! {
        case DestinationType.Ads:
            navigationItem.title = "Ads"
            break
        case DestinationType.SCM:
            navigationItem.title = "SCM"
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentState == nil {
            return 0
        }
        
        switch currentState! {
        case ViewState.Summary:
            if let _ = summaries {
                return summaries!.count
            }
            return 0;
        case ViewState.Detail:
            if let _ = details {
                return 0;
            }
            return details!.count + 1 //extra for graph
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch currentState! {
        case ViewState.Summary:
            let summaryCell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! SummaryCell
            let summary = summaries![indexPath.row]
            summaryCell.summary = summary
            return summaryCell
        case ViewState.Detail:
            let detailCell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCell
            return detailCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        switch currentState! {
        case ViewState.Summary:
            //var summary = summaries![indexPath.row]
            let reportViewController = UIStoryboard.reportViewController()
            reportViewController?.currentDestination = currentDestination
            reportViewController?.currentState = ViewState.Detail
            navigationController?.pushViewController(reportViewController!, animated: true)
            
            break
        case ViewState.Detail:
            break
            
        }
    }
    
  
    
    func reloadView(viewType: String, destinationType: String) {
        
        var viewState = ViewState.Summary
        if viewType == "Detail" {
            viewState = ViewState.Detail
        }
        
        var destination = DestinationType.Ads
        if destinationType == "SCM" {
            destination = DestinationType.SCM
        }

        
        let containerViewController = ContainerViewController (viewState: viewState, destinationType: destination)
        
        presentViewController(containerViewController, animated: true) { () -> Void in
            
        }
        
        delegate?.collapseSidePanels?()
        
    }
    
    func configureViewController(viewType: String, destinationType: String, containerViewController: ContainerViewController) {
        switch viewType {
        case "Summary":
            containerViewController.reportViewController.currentState = ViewState.Summary
            //containerViewController.homeViewController.fetchMentionsTimeLine()
            
        case "Detail":
            containerViewController.reportViewController.currentState = ViewState.Detail
            //containerViewController.homeViewController.fetchUserTimeLine()
            
        default:
            break
        }
        
        switch destinationType {
        case "SCM":
            containerViewController.reportViewController.currentDestination = DestinationType.SCM
        case "Ads":
            containerViewController.reportViewController.currentDestination = DestinationType.Ads
        default:
            break
        }
        containerViewController.reportViewController.loadData()
        containerViewController.reportViewController.navigationItem.title = destinationType
    }
    
    func menuItemSelected(menuItem: MenuItem) {
        reloadView("Summary", destinationType: menuItem.title)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getSummaryEndpoint() -> String {
        switch currentDestination! {
        case DestinationType.SCM:
                return "http://sem-dev05.sv.walmartlabs.com:3000/api/metrics/summary.json"
        case DestinationType.Ads:
                return "https://wmx.walmartlabs.com/wpa/organizations/10001/organization_reports/1/summary?field_description=true&user_token=249e2db392fc0d55b484f53464e4e689b7bd6830ba8987927af5b9a8677e9b6edeb77f83722028dca672793a41199d36af34e68cee8ab0604c42216b07b5e399"
    
        }
    }

}
