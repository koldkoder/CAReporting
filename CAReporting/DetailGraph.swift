//
//  DetailGraph.swift
//  CAReporting
//
//  Created by Chintan Rita on 10/19/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit
import Charts

class DetailGraph: UIViewController, ChartViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "test"
    }

    func setupChart(data: LineChartData) {
        let chart: LineChartView!
        chart.delegate = self
        chart.backgroundColor = UIColor.blackColor()
        chart.descriptionText = "Test"
        chart.noDataTextDescription = "No Data Available"
        chart.drawGridBackgroundEnabled = false
        chart.dragEnabled = true;
        chart.setScaleEnabled(true);
        chart.pinchZoomEnabled = false;
        chart.setViewPortOffsets(left: 10, top: 0, right: 10, bottom: 0);
        
        chart.legend.enabled = false
        
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = false
        
        chart.data = data;
        chart.animate(xAxisDuration: 2.5)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
