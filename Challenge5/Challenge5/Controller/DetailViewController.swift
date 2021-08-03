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
            capital { font-family: sans-serif; font-size: 125%; }
            population { font-family: sans-serif; font-size: 125%; }
            area { font-family: sans-serif; font-size: 125%; }
            gini { font-family: sans-serif; font-size: 125%; }
            </style>
            </head>
            <body>
            <h3>\(detailItem.name)</h3>
            <p>Capital: \(detailItem.capital)</p>
            <p>Population: \(detailItem.population)</p>
            <p>Area: \(detailItem.area)km2</p>
            <p>Gini: \(detailItem.gini)</p>
            </body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
