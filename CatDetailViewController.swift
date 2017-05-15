//
//  CatDetailViewController.swift
//  Cats
//
//  Created by Deva Vrijma on 13-05-17.
//  Copyright © 2017 App-a-tize. All rights reserved.
//

import UIKit

class CatDetailViewController: UIViewController {
    
    @IBOutlet weak var catImage: UIImageView!
    var imageLoader: UIImage? = nil
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        catImage.image = imageLoader!
        loadText()
    }
    
    func loadText(){
        let myURLString = "httpa://loripsum.net/api"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            print("HTML : \(myHTMLString)")
            label.text = myHTMLString
        } catch let error {
            print("Error: \(error)")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Function to set image after the view is fully loaded
    func setImage(image:UIImage){
        imageLoader = image
        if isViewLoaded {
            catImage.image = imageLoader
        }
    }


}
