//
//  LoginVKViewController.swift
//  Weather
//
//  Created by Matthew on 29.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit
import WebKit

class LoginVKViewController: UINavigationController {
    
    
    //@IBOutlet weak
    var webview: WKWebView?{
        didSet{
            print(#function)
            webview?.navigationDelegate = self
            
            if webview != nil  {
                loadVKLoginPage()
            }
        }
    }
    
    @objc func successLogin(_ notification: Notification){
        
        DispatchQueue.main.async {
            
            self.webview?.removeFromSuperview()
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
        
    }
    
    func cleanWebViewCookies()  {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        NotificationCenter.default.addObserver(self, selector: #selector(successLogin), name: Notification.Name("SuccessLogin"), object: nil)
        cleanWebViewCookies()
        webview = WKWebView()
        webview!.frame = view.bounds
        view.addSubview(webview!)
        
        // Do any additional setup after loading the view.
    }
    
    func loadVKLoginPage() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7553214"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.52")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webview!.load(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginVKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        print(params)
        if let token = params["access_token"],
            let userId = params["user_id"]{
            Session.currentUser.token = token
            Session.currentUser.userId = userId
            decisionHandler(.cancel)
            
            NotificationCenter.default.post(Notification(name: Notification.Name("SuccessLogin")))
            
        } else {
          decisionHandler(.cancel)
        }
    }
}

