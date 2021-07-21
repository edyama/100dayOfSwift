//
//  DetailViewController.swift
//  Project7
//
//  Created by Ed Yama on 19/07/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, inital-scale=1">
            <style>
            title { font-family: sans-serif; font-size: 125%; font-weight: bold; }
            body { font-family: sans-serif; font-size: 125%; }
            </style>
            </head>
            <body>
            <h3>\(detailItem.title)</h3>
            <p>\(detailItem.body)</p>
            </body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
