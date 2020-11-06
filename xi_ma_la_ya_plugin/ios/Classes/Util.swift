//
//  Util.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/4.
//

import Foundation

func findCurrentShowingViewController() -> UIViewController? {
    func findCurrentShowingViewControllerFrom(vc: UIViewController) -> UIViewController {
        if let nextRootVC = vc.presentedViewController {
            return findCurrentShowingViewControllerFrom(vc: nextRootVC)
        } else if let nextRootVC = vc as? UITabBarController, let nextRootVCVC = nextRootVC.selectedViewController {
            return findCurrentShowingViewControllerFrom(vc: nextRootVCVC)
        } else if let nextRootVC = vc as? UINavigationController, let nextRootVCVC = nextRootVC.visibleViewController {
            return findCurrentShowingViewControllerFrom(vc: nextRootVCVC)
        } else {
            return vc
        }
    }
//    UIApplication.shared.delegate?.window??.rootViewController
    if let vc = UIApplication.shared.keyWindow?.rootViewController {
        return findCurrentShowingViewControllerFrom(vc: vc)
    } else {
        return nil
    }
}

func loadNetworkUIImage(path: String) -> UIImage? {
    if let url: NSURL = NSURL(string: path), let data = NSData(contentsOf: url as URL) {
        return UIImage(data: data as Data)
    }
    return nil
}
