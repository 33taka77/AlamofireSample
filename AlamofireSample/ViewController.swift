//
//  ViewController.swift
//  AlamofireSample
//
//  Created by Aizawa Takashi on 2015/03/18.
//  Copyright (c) 2015年 Aizawa Takashi. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var dearchText:String = ""
    var images:[NSDictionary] = []
    var prevSpace_x:CGFloat = 0
    var prevSpace_y:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(searchBarText:UISearchBar!) {
        searchBarText.resignFirstResponder()
        self.dearchText = searchBarText.text
        prevSpace_x = self.view.frame.size.width
        self.fetchImages()
    }
    func fetchImages() {
        let url :String = "https://api.flickr.com/services/rest/"
        var parameters:Dictionary = [
            "method"         : "flickr.photos.search",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "per_page"       : "99",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_m,url_o",
        ]
        parameters["text"] = self.dearchText
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseJSON {(request, response, JSON, error) in
                println(JSON)
                let dict:NSDictionary = JSON as NSDictionary
                let objects:NSDictionary = dict.objectForKey("photos") as NSDictionary
                let array:[NSDictionary] = objects["photo"] as [NSDictionary]
                self.images = array
                self.collectionView.reloadData()
        }
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell :ThumbnailCollectionViewCell! = self.collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as ThumbnailCollectionViewCell

        cell.imgeView.image = getThumbnailData(indexPath.row)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let image:UIImage? = self.getThumbnailData(indexPath.row)!
        var x:CGFloat = 50
        var y:CGFloat = 50
        if image != nil {
            if image!.size.width > image!.size.height {
                x = image!.size.width > self.view.frame.size.width ? self.view.frame.size.width:image!.size.width
                y = image!.size.height
                if x > prevSpace_x {
                    x = prevSpace_x
                    y = prevSpace_x/image!.size.width*image!.size.height
                }
            }else{
                x = 150.0
                y = x/image!.size.width*image!.size.height
            }
            prevSpace_x = self.view.frame.size.width - x
        }
        return CGSizeMake(x, y)
    }
    
    func getThumbnailData( index:Int )->UIImage?{
        let item = self.images[index] as NSDictionary
        let photoUrlString:String = item["url_m"] as String
        let url : NSURL = NSURL(string: photoUrlString)!
        var image:UIImage? = nil
        let request : NSURLRequest = NSURLRequest(URL: NSURL(string: photoUrlString)!)
        Alamofire.request(.GET, url).response { (request, response, object, error) -> Void in
            image = UIImage(data: object as NSData)
        }
        return image
    }
}

