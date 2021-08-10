//
//  PersonViewController.swift
//  Challenge4
//
//  Created by Ed Yama on 10/08/21.
//

import UIKit

class PersonViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
    var tableViewController = ViewController()
    var person: Person?
        
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = person?.image
        
        guard let image = person?.image else { return }
        let path = tableViewController.getDocumentsDirectory().appendingPathComponent(image)
        imageView.image = UIImage(contentsOfFile: path.path)
        
        name.text = person?.name
    }
}
