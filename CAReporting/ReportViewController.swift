//
//  ReportViewController.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit
import JTProgressHUD
import Charts

enum ViewState{
    case Summary
    case Detail
}

enum DestinationType {
    case Ads
    case SEM
}

@objc protocol ReportViewControllerDelegate {
    optional func collapseSidePanels()
    optional func hideHamburgerButton()
    optional func showHamburgerButton()
}

class ReportViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, SidePanelViewControllerDelegate, ChartViewDelegate{

    @IBOutlet weak var reportTableView: UITableView!
    
    var summaries: [Summary]?
    var details: [Detail]?
    var currentState: ViewState?
    var currentDestination: DestinationType?
    
    var delegate: ReportViewControllerDelegate?
    var selectedSummary: Summary?
    var selectedGraphMetric = 0

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.rowHeight = UITableViewAutomaticDimension
        reportTableView.estimatedRowHeight = 100
        JTProgressHUD.show()
        self.topConstraint.constant = 0
        if currentState != nil && currentDestination != nil {
            setNavTitle()
            loadData()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if currentState != nil {
            switch currentState! {
            case ViewState.Summary:
                delegate?.hideHamburgerButton!()
                break;
            case ViewState.Detail:
                delegate?.showHamburgerButton!()
                break;
            }
        }
        
    }
    
    func loadData() {
        switch currentState! {
        case ViewState.Summary:
            self.reportTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            let endpointUrl = getSummaryEndpoint()
            CARClient.sharedInstance.getSummary(endpointUrl, completion: { (summaries, error) -> () in
                JTProgressHUD.hide()
                if (summaries != nil) {
                    self.summaries = summaries
                    self.reportTableView.reloadData()
                }
            })
            break
        case ViewState.Detail:
            self.reportTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            let endpointUrl = getDetailEndpoint()
            CARClient.sharedInstance.getDetails(endpointUrl, completion: { (details, error) -> () in
                JTProgressHUD.hide()
                if (details != nil) {
                    self.details = details
                    if (self.details![self.selectedGraphMetric].hasGraph()) {
                        print("Plotting graph for \(self.details![self.selectedGraphMetric].key)")
                        self.addGraph(self.details![self.selectedGraphMetric])
                    }
                    self.reportTableView.reloadData()
                }
            })
            break
        }
        
    }
    
    func addGraph(detail:Detail) {
        self.topConstraint.constant = 200
        let y = self.navigationController?.navigationBar.frame.height
        let frame = CGRectMake(self.view.frame.origin.x, y!+5, self.view.frame.width, 200)
        let chart = LineChartView(frame: frame)
        chart.layer.borderColor = UIColor.lightGrayColor().CGColor
        chart.layer.borderWidth = 1
        chart.delegate = self
        chart.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(chart)

        chart.descriptionText = detail.displayString
        chart.descriptionFont = UIFont(name: "Helvetica Neue", size: 17.0)
        chart.noDataTextDescription = "Data not available."
        
        chart.drawGridBackgroundEnabled = false
        chart.dragEnabled = true
        chart.highlightEnabled = true
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = false
        chart.setViewPortOffsets(left: 20, top: 20, right: 20, bottom: 20)
        
        chart.legend.enabled = false
        chart.xAxis.enabled = false
        
        chart.leftAxis.enabled = true
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.drawGridLinesEnabled = true
        chart.leftAxis.gridColor = UIColor.lightGrayColor()
        
        chart.rightAxis.enabled = true
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.gridColor = UIColor.lightGrayColor()

        var xVals = [String]()
        let yVals = LineChartDataSet()
        yVals.circleRadius = 2
        yVals.circleColors = [ChartColorTemplates.colorful()[1]]
        yVals.circleHoleColor = ChartColorTemplates.colorful()[1]
        yVals.colors = [ChartColorTemplates.colorful()[1]]
        yVals.lineWidth = 1.5
        yVals.drawValuesEnabled = false

        var index = 0
        for dataItem in detail.data {
            let metrics = dataItem["metrics"] as! NSDictionary
            let dateString = dataItem["date"] as! String
            xVals.append(dateString)
            let chartDataEntry = ChartDataEntry(value: metrics[detail.key] as! Double, xIndex: index++)
            yVals.addEntry(chartDataEntry)
        }
        
        chart.data = LineChartData(xVals: xVals, dataSet: yVals)
        
        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    func setNavTitle() {
        if currentDestination == nil {
            return
        }
        switch currentDestination! {
        case DestinationType.Ads:
            navigationItem.title = "Ads"
            break
        case DestinationType.SEM:
            navigationItem.title = "SEM"
            break
        }
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let valueString = self.details![self.selectedGraphMetric].getValueString(entry.value)
        chartView.descriptionText = self.details![self.selectedGraphMetric].displayString + ": \(valueString)"
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
                return details!.count
            }
            return 0;
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
            let detail = details![indexPath.row]
            detailCell.detail = detail
            return detailCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        switch currentState! {
        case ViewState.Summary:
            let reportViewController = UIStoryboard.reportViewController()
            reportViewController?.currentDestination = currentDestination
            reportViewController?.currentState = ViewState.Detail
            reportViewController?.selectedSummary = self.summaries![indexPath.row]
            reportViewController?.delegate = self.delegate
            navigationController?.pushViewController(reportViewController!, animated: true)
            break
        case ViewState.Detail:
            self.selectedGraphMetric = indexPath.row
            let detailToBePlotted = self.details![self.selectedGraphMetric]
            if (detailToBePlotted.hasGraph()) {
                print("Plotting graph for \(detailToBePlotted.key)")
                self.addGraph(detailToBePlotted)
            }
            break
            
        }
    }
    
  
    
    func reloadView(viewType: String, destinationType: String) {
        
        var viewState = ViewState.Summary
        if viewType == "Detail" {
            viewState = ViewState.Detail
        }
        
        var destination = DestinationType.Ads
        if destinationType == "SEM" {
            destination = DestinationType.SEM
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
        case "SEM":
            containerViewController.reportViewController.currentDestination = DestinationType.SEM
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.loadData()
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
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
        case DestinationType.SEM:
                return "http://sem-dev05.sv.walmartlabs.com:3000/api/metrics/summary.json"
        case DestinationType.Ads:
                return "https://wmx.walmartlabs.com/wpa/organizations/10001/organization_reports/1/summary?field_description=true&user_token=249e2db392fc0d55b484f53464e4e689b7bd6830ba8987927af5b9a8677e9b6edeb77f83722028dca672793a41199d36af34e68cee8ab0604c42216b07b5e399"
    
        }
    }
    
    func getDetailEndpoint() -> String {
        switch currentDestination! {
        case DestinationType.SEM:
            return "http://sem-dev05.sv.walmartlabs.com:3000/api/metrics/details.json?time_period_key=" + (selectedSummary?.key)!
        case DestinationType.Ads:
            return "https://wmx.walmartlabs.com/wpa/organizations/10001/organization_reports/1/by_range?field_description=true&user_token=249e2db392fc0d55b484f53464e4e689b7bd6830ba8987927af5b9a8677e9b6edeb77f83722028dca672793a41199d36af34e68cee8ab0604c42216b07b5e399&time_period_key=" + (selectedSummary?.key)!
        }
    }

}
