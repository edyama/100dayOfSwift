//
//  ActionViewController.swift
//  Extension
//
//  Created by Ed Yama on 29/07/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var savedSites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCommand))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.title = self?.pageTitle
                    }
                    
                    self?.loadJavaScriptCodeFor(website: self?.pageTitle ?? "")
                }
            }
        }
    }

    @objc func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }

    @objc func addCommand() {
        let ac = UIAlertController(title: "User", message: "Choose your command", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Title document", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert(document.title)"
        }))
        ac.addAction(UIAlertAction(title: "URL document", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert(document.URL)"
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectRange = script.selectedRange
        script.scrollRangeToVisible(selectRange)
    }
    
    func loadJavaScriptCodeFor(website: String) {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: website) as? Data {
            let jsonDecoder = JSONDecoder()
            if let websiteCode = try? jsonDecoder.decode(WebsiteJavaScriptCode.self, from: savedData) {
                DispatchQueue.main.async { [weak self] in self?.script.text = websiteCode.code }
                print("loaded code from \(websiteCode.title)")
            } else {
                print("no data loaded for \(website)")
                DispatchQueue.main.async { [weak self] in self?.script.text = "// enter custom JavaScript code" }
            }
        } else {
            print("no user data for \(website)")
        }
    }
}
