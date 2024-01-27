//
//  ViewController.swift
//  boiflix
//
//  Created by Duy Ha on 16/12/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        
        //tab bar variables
        let tab1 = UINavigationController(rootViewController: HomeViewController())
        let tab2 = UINavigationController(rootViewController: UpcomingViewController())
        let tab3 = UINavigationController(rootViewController: SearchViewController())
        let tab4 = UINavigationController(rootViewController: DownloadsViewController())
        
        //set Icon for tab bar
        tab1.tabBarItem.image = UIImage(systemName: "house")
        tab2.tabBarItem.image = UIImage(systemName: "play.circle")
        tab3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        tab4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        //set title for Tab Bar
        tab1.tabBarItem.title = "Home"
        tab2.tabBarItem.title = "Coming"
        tab3.tabBarItem.title = "Top Search"
        tab4.tabBarItem.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([tab1,tab2,tab3,tab4], animated: true)
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedViewController = selectedViewController, let toIndex = viewControllers?.firstIndex(of: viewController) else {
            return false
        }
        guard toIndex != selectedIndex else { return false}

        animateTransition(from: selectedViewController.view, to: viewController.view, toIndex: toIndex)

        return true
    }

    // Animated Slide when changing tab
    private func animateTransition(from fromView: UIView, to toView: UIView, toIndex: Int) {
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let direction: CGFloat = toIndex > selectedIndex ? 1.0 : -1.0
        
        func viewFrame(_ view: UIView) -> CGRect {
            let frame = CGRect(x: view.frame.origin.x - direction * screenWidth, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
            return frame
        }

        UIView.animate(withDuration: 0.2, animations: {
            // Slide the fromView to the left or right based on the direction
            fromView.frame = viewFrame(fromView)

            // Slide the toView to its original position
            toView.frame = viewFrame(toView)
        })
    }
}

