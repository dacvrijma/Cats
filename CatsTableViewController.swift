//
//  CatsTableViewController.swift
//  Cats
//
//  Created by Deva Vrijma on 13-05-17.
//  Copyright © 2017 App-a-tize. All rights reserved.
//

import UIKit

class CatsTableViewController: UITableViewController {
    
    var data = [UIImage]()
    var cellWidth: CGFloat = 100
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set pull to refresh action
        self.refreshControl?.addTarget(self, action: #selector(CatsTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        // Load all images on first load
        loadImages()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // On refresh reload all images
        loadImages()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func loadImages(){
        data = []
        for _ in 0..<99{
            loadImage(final: false)
        }
        loadImage(final: true)
    }
    
    func loadImage(final:Bool) {
        let url = URL(string: "https://thecatapi.com/api/images/get?format=src&type=gif")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("There was an error: \(e)")
            } else {
                // No errors were found.
                if response as? HTTPURLResponse != nil {
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        if let image = UIImage.gif(data: imageData){
                            self.data.append((image))
                            if final{
                                self.table.reloadData()
                            }
                        } else {
                            // If the image isn't valid, try again
                            self.loadImage(final: final)
                        }
                    } else {
                        print("The data returned is nil")
                    }
                } else {
                    print("There was no response from the server")
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:CatDetailViewController = segue.destination as! CatDetailViewController
        detailView.setImage(image: data[table.indexPathForSelectedRow!.row])
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cat", for: indexPath) as! CatTableViewCell
        cell.catImage.image = data[indexPath.row]
        
        // Calculate correct height in aspect to thw width
        cell.catImage.autoresizingMask = []
        let width = (data[indexPath.row].size.width)
        let height = (data[indexPath.row].size.height)
        let ratio = height / width
        cellWidth = cell.bounds.width
        cell.catImage.frame.size.height = cell.bounds.width * ratio
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set correct row height
        let width = (data[indexPath.row].size.width)
        let height = (data[indexPath.row].size.height)
        let ratio = height / width
        return cellWidth * ratio
    }
    
}
