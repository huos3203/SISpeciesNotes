//
//  FlickrSearcher.swift
//  flickrSearch
//
//  Created by Richard Turton on 31/07/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import UIKit

let apiKey = "294e72a918044d22512d1188d7da408d"

struct FlickrSearchResults {
  let searchTerm : String
  let searchResults : [FlickrPhoto]
}

class FlickrPhoto : Equatable {
  let photoID : String
  let title: String
  private let farm : Int
  private let server : String
  private let secret : String
  
    //完成下载闭包
  typealias ImageLoadCompletion = (image: UIImage?, error: NSError?) -> Void
  
    //构造器
  init (photoID:String, title:String, farm:Int, server:String, secret:String) {
    self.photoID = photoID
    self.title = title
    self.farm = farm
    self.server = server
    self.secret = secret
  }
  
  func flickrImageURL(size:String = "m") -> NSURL {
    return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")!
  }
  
    //下载预览图
  func loadThumbnail(completion: ImageLoadCompletion) {
    loadImageFromURL(flickrImageURL("m")) { image, error in
      completion(image: image, error: error)
    }
  }

    //下载原图
  func loadLargeImage(completion: ImageLoadCompletion) {
    loadImageFromURL(flickrImageURL("b"), completion: completion)
  }
  
  func loadImageFromURL(URL: NSURL, completion: ImageLoadCompletion) {
    let loadRequest = NSURLRequest(URL: URL)
    NSURLConnection.sendAsynchronousRequest(loadRequest,
      queue: NSOperationQueue.mainQueue()) {
        response, data, error in
        
        if error != nil {
          completion(image: nil, error: error)
          return
        }
        
        if data != nil {
          completion(image: UIImage(data: data!), error: nil)
          return
        }
        
        completion(image: nil, error: nil)
    }
  }
}

//点赞
extension FlickrPhoto {
  var isFavourite: Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey(photoID)
    }
    set {
      NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: photoID)
    }
  }
}

//自定义 == 方法
func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
  return lhs.photoID == rhs.photoID
}

class Flickr {
  
  let processingQueue = NSOperationQueue()
  
  func searchFlickrForTerm(searchTerm: String, completion : (results: FlickrSearchResults?, error : NSError?) -> Void){
    
    let searchURL = flickrSearchURLForSearchTerm(searchTerm)
    let searchRequest = NSURLRequest(URL: searchURL)
    
    NSURLConnection.sendAsynchronousRequest(searchRequest, queue: processingQueue) {response, data, error in
      if error != nil {
        completion(results: nil,error: error)
        return
      }
      
      var JSONError : NSError?
      let resultsDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
      if JSONError != nil {
        completion(results: nil, error: JSONError)
        return
      }
      
      switch (resultsDictionary!["stat"] as! String) {
      case "ok":
        print("Results processed OK")
      case "fail":
        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:resultsDictionary!["message"]!])
        completion(results: nil, error: APIError)
        return
      default:
        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
        completion(results: nil, error: APIError)
        return
      }
      
      let photosContainer = resultsDictionary!["photos"] as! NSDictionary
      let photosReceived = photosContainer["photo"] as! [NSDictionary]
      
      let flickrPhotos : [FlickrPhoto] = photosReceived.map {
        photoDictionary in
        
        let photoID = photoDictionary["id"] as? String ?? ""
        let title = photoDictionary["title"] as? String ?? ""
        let farm = photoDictionary["farm"] as? Int ?? 0
        let server = photoDictionary["server"] as? String ?? ""
        let secret = photoDictionary["secret"] as? String ?? ""
        
        let flickrPhoto = FlickrPhoto(photoID: photoID, title: title, farm: farm, server: server, secret: secret)
        
        return flickrPhoto
      }
      
      dispatch_async(dispatch_get_main_queue(), {
        completion(results:FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos), error: nil)
      })
    }
  }
  
  private func flickrSearchURLForSearchTerm(searchTerm:String) -> NSURL {
    let escapedTerm = searchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=30&format=json&nojsoncallback=1"
    return NSURL(string: URLString)!
  }
  
  
}
