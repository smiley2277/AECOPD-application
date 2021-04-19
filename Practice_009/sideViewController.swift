//
//  sideViewController.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/3/27.
//

import Foundation
import UIKit
import SideMenu

class sideViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var menuAnimator : MenuTransitionAnimator!
    override func viewDidLoad() {
        menuAnimator = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menu = segue.destination 
        menu.transitioningDelegate = self
        menu.modalPresentationStyle = .custom
    }

    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
        source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return menuAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
}
