//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Ed Yama on 28/07/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: Country?
    
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
            name { font-family: sans-serif; font-size: 125%; font-weight: bold; }
            capitalCity { font-family: sans-serif; font-size: 125%; }
            </style>
            </head>
            <body>
            <h3>\(detailItem.name)</h3>
            <p>\(detailItem.capitalCity)</p>
            </body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
