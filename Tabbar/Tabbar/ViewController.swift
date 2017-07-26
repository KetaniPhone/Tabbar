//
//  ViewController.swift
//  Tabbar
//
//  Created by Ketan on 7/26/17.
//  Copyright © 2017 kETANpATEL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet private weak var btnTab1: UIButton!
    @IBOutlet private weak var btnTab2: UIButton!
    @IBOutlet private weak var btnTab3: UIButton!
    
    @IBOutlet private weak var viewLine: UIView!
    @IBOutlet private weak var constantViewLeft: NSLayoutConstraint!
    
    var tab1VC:Tab1VC! = nil
    var tab2VC:Tab2VC! = nil
    var tab3VC:Tab3VC! = nil
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 0
        createPageViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Custom Methods
    
    private func selectedButton(btn: UIButton) {
        
        btn.setTitleColor(UIColor.black, for: .normal)
        
        constantViewLeft.constant = btn.frame.origin.x
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func unSelectedButton(btn: UIButton) {
        btn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
    
    //MARK: - IBaction Methods
    
    @IBAction private func btnOptionClicked(btn: UIButton) {
        
        pageController.setViewControllers([arrVC[btn.tag-1]], direction: UIPageViewControllerNavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in
        })
        
        resetTabBarForTag(tag: btn.tag-1)
    }
    
    //MARK: - CreatePagination
    
    private func createPageViewController() {
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: self.view.frame.size.height-65)
        }
        
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tab1VC = homeStoryboard.instantiateViewController(withIdentifier: "Tab1VC") as! Tab1VC
        tab2VC = homeStoryboard.instantiateViewController(withIdentifier: "Tab2VC") as! Tab2VC
        tab3VC = homeStoryboard.instantiateViewController(withIdentifier: "Tab3VC") as! Tab3VC
        
        arrVC = [tab1VC, tab2VC, tab3VC]
        
        pageController.setViewControllers([tab1VC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParentViewController: self)
    }
    
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.index(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            resetTabBarForTag(tag: currentPage)
        }
    }
    
    //MARK: - Set Top bar after selecting Option from Top Tabbar
    
    private func resetTabBarForTag(tag: Int) {
        
        var sender: UIButton!
        
        if(tag == 0) {
            sender = btnTab1
        }
        else if(tag == 1) {
            sender = btnTab2
        }
        else if(tag == 2) {
            sender = btnTab3
        }
        
        currentPage = tag
        
        unSelectedButton(btn: btnTab1)
        unSelectedButton(btn: btnTab2)
        unSelectedButton(btn: btnTab3)
        
        
        selectedButton(btn: sender)
        
    }
    
    //MARK: - UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let xFromCenter: CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor: CGFloat = CGFloat(viewLine.frame.size.width) * CGFloat(currentPage)
        let xPosition: CGFloat = xCoor - xFromCenter/CGFloat(arrVC.count)
        constantViewLeft.constant = xPosition
    }
    
}
