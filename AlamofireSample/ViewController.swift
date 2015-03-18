//
//  ViewController.swift
//  AlamofireSample
//
//  Created by Aizawa Takashi on 2015/03/18.
//  Copyright (c) 2015年 Aizawa Takashi. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var dearchText:String = ""
    var images:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(searchBarText:UISearchBar!) {
        searchBarText.resignFirstResponder()
        dearchText = searchBarText.text
        self.fetchImages()
    }
    func fetchImages() {
        let url :String = "https://api.flickr.com/services/rest/"
        let parameters:Dictionary = [
            "method"         : "flickr.interestingness.getList",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "per_page"       : "99",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_m,url_o",
        ]

        Alamofire.request(.GET, url, parameters: parameters)
            .responseJSON {(request, response, JSON, error) in
                println(JSON)
                let dict:[String: AnyObject] = JSON as Dictionary<String, AnyObject>
                let objects:[String: AnyObject] = dict["potos"] as Dictionary<String, AnyObject>
                let array = objects.indexForKey("photo")
                for let item = array as? [Dictionary<String, AnyObject>] {
                    
                }
                self.images = array as [Dictionary<String, AnyObject>]
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell :UICollectionViewCell! = self.collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as UICollectionViewCell
        return cell
    }
}

