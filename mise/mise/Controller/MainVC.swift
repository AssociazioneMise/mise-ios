//
//  MainVC.swift
//  mise
//
//  Created by Pablo Pfister on 14.05.17.
//  Copyright © 2017 Pablo Pfister. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!

    private let BASE_URL = "http://ticino.swiss-mise.info/"
    private let INDEX_PAGE = "index/index/index/"
    private var request: URLRequest!
    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        checkCanGoBackAndForward()
        
        let url = URL(string: "\(BASE_URL)\(INDEX_PAGE)")!
        request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    // MARK: UIWebViewDelegate methods
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        checkCanGoBackAndForward()
        
        if (navigationType == UIWebViewNavigationType.linkClicked && !String(describing: request.url!).hasPrefix(BASE_URL)) {
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        adaptContentSize(of: webView)
        
        // Assign scroll view delegate only here so that the content size can be adapted
        webView.scrollView.delegate = self
    }
    
    // MARK: UIScrollViewDelegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // Prevent from auto zooming on inputs
        return nil
    }
    
    // MARK: private methods
    
    private func adaptContentSize(of webView: UIWebView) {
        let contentSize = webView.scrollView.contentSize
        let viewSize = webView.bounds.size
        
        let resizeFactor = viewSize.width / contentSize.width
        
        webView.scrollView.minimumZoomScale = resizeFactor
        webView.scrollView.maximumZoomScale = resizeFactor
        webView.scrollView.zoomScale = resizeFactor
    }
    
    private func checkCanGoBackAndForward() {
        if webView.canGoBack {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
        
        if webView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
    }
    
    // MARK: IBActions

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        if webView.isLoading {
            webView.stopLoading()
        }
        webView.loadRequest(request)
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forwardTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
}
