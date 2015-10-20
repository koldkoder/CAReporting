//
//  ContainerViewController.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit


class ContainerViewController: UIViewController {
    
    var reportNavigationController: UINavigationController!
    var reportViewController: ReportViewController!
    
    var reportViewState: ViewState?
    var reportDestinationType: DestinationType?
    var hamburgerButton: UIButton?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(viewState: ViewState.Summary, destinationType: DestinationType.SEM)
    }
    
    init(viewState: ViewState, destinationType: DestinationType) {
        reportViewState = viewState
        reportDestinationType = destinationType
        super.init(nibName: nil, bundle: nil)
    }
    
    var leftNavExpanded : Bool = false {
        didSet {
            showShadowForCenterViewController(leftNavExpanded)
        }
    }
    
    func openSidePanel() {
        if !leftNavExpanded {
            addLeftPanelViewController()
            animateLeftPanel(true)
        }
        else {
            animateLeftPanel(false)
        }
    }
    
    func hideHamburgerButton() {
        hamburgerButton?.hidden = true
    }
    
    func showHamburgerButton() {
        if (self.view.frame.height > self.view.frame.width) {
            let frame = CGRectMake(10, 30, 32, 32)
            hamburgerButton!.frame = frame;
        }
        else {
            let frame = CGRectMake(10, 0, 32, 32)
            hamburgerButton!.frame = frame;
        }
        hamburgerButton?.hidden = false
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            if size.height > size.width {
                let frame = CGRectMake(10, 30, 32, 32)
                hamburgerButton!.frame = frame;
            }else{
                let frame = CGRectMake(10, 0, 32, 32)
                hamburgerButton!.frame = frame;
            }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    
    var leftViewController: SidePanelViewController?
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportViewController = UIStoryboard.reportViewController()
        reportViewController.currentState = reportViewState!
        reportViewController.currentDestination = reportDestinationType!
        reportViewController.delegate = self
        reportNavigationController = UIStoryboard.reportNavigationController()
        reportNavigationController.setViewControllers( [reportViewController], animated: true)
        
        let hamburgerImage = UIImage(named: "hamburger")
        hamburgerButton = UIButton(type: UIButtonType.Custom)
        hamburgerButton!.setBackgroundImage(hamburgerImage, forState: UIControlState.Normal)
        hamburgerButton!.addTarget(self, action: "openSidePanel", forControlEvents: UIControlEvents.TouchUpInside)
        
        showHamburgerButton()
        hamburgerButton!.setBackgroundImage(hamburgerImage, forState: UIControlState.Normal)
        reportNavigationController.view.addSubview(hamburgerButton!)
        
        view.addSubview(reportNavigationController.view)
        addChildViewController(reportNavigationController)
        reportNavigationController.didMoveToParentViewController(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        reportNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ContainerViewController: ReportViewControllerDelegate {
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController!.delegate = reportViewController
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            leftNavExpanded = true
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(reportNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.leftNavExpanded = false
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition position: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.reportNavigationController.view.frame.origin.x = position
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            reportNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            reportNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func collapseSidePanels() {
        if(leftNavExpanded) {
            animateLeftPanel(false)
        }
        
    }
    
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        switch(recognizer.state) {
        case .Began:
            if (!leftNavExpanded) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                }
                //showShadowForCenterViewController(true)
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (leftViewController != nil) {
                //animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
}

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MenuViewController") as? SidePanelViewController
    }
    
    class func reportViewController() -> ReportViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("ReportViewController") as? ReportViewController
    }
    
    class func reportNavigationController() -> UINavigationController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("ReportNavigationController") as! UINavigationController
    }
    
}