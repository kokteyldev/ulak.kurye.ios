//
//  OnboardingVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

final class OnboardingVC: BaseVC, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
        
    // MARK: - Setup Slides
    private lazy var pages: [OnboardingView] = {
        return [OnboardingView(title: "onboarding_1_title".localized, description: "onboarding_1_desc".localized, image: UIImage(named:"ic.onboarding.1"), frame: self.view.frame),
                OnboardingView(title: "onboarding_2_title".localized, description: "onboarding_2_desc".localized, image: UIImage(named:"ic.onboarding.2"), frame: self.view.frame),
                OnboardingView(title: "onboarding_3_title".localized, description: "onboarding_3_desc".localized, image: UIImage(named:"ic.onboarding.3"), frame: self.view.frame),
                OnboardingView(title: "onboarding_4_title".localized, description: "onboarding_4_desc".localized, image: UIImage(named:"ic.onboarding.4"), frame: self.view.frame)]
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(pageControl)
        setupScrollView(pages: pages)
        scrollView.delegate = self
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }
    
    // MARK: - Setup ScrollView
    func setupScrollView(pages: [OnboardingView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(pages[i])
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    // MARK: - Presentation
    static func presentAsRoot() {
        guard let window = UIApplication.rootWindow else { return }
        
        DispatchQueue.main.async {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                UIView.performWithoutAnimation({
                    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                    let rootController = storyboard.instantiateInitialViewController() as! OnboardingVC
                    window.rootViewController = rootController
                })
            }, completion: nil)
        }
    }
}


