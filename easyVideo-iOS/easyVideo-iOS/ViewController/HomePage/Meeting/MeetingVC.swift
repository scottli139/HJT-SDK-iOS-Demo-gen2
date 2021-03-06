//
//  MeetingVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit
import WebKit

class MeetingVC: BaseViewController, WKScriptMessageHandler, WKNavigationDelegate {

    var webKit: WKWebView!
    var maskView: HLogingView?
    var loginToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createWKWebView()
        
        loginToken = ""
        
        if !appDelegate.isLogin {
            whetherTheLogin()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hiddenNav()
        
        if getUserParameter(username) != nil {
            let token = appDelegate.evengine.getUserInfo()?.token
            if token != nil {
                if loginToken != token {
                    loginToken = token!
                    loadMeetingVCWeb()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webKit.frame = view.frame
        maskView?.frame = view.frame
    }
    
    // MARK: WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        userContentController_(userContentController, didReceive: message)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        }else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod) == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, card)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        didStartProvisionalNavigation()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinishNavigation(webView)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        didFailProvisionalNavigation()
    }
    
}
