//
//  HttpConnect.swift
//  Shared Library
//
//  Created by Jirapas Chiradechwiroj on 10/11/2560 BE.
//  Copyright © 2560 Jirapas Chiradechwiroj. All rights reserved.
//
//
//  HttpConnect.swift
//
//
//  Created by Jirapas Chiradechwiroj on 10/9/2560 BE.
//
//

import UIKit
import CoreFoundation
import Foundation
//
//public protocol HttpConnectDelegate: NSobjectProtocol {
//    
//    optional func requestURL(url: NSURL) -> String
//    optional func requestURL(url: NSURL) -> (String, NSDictionary)
//}

public class HttpConnect :NSURLRequest {
//    public weak var delegate: HttpConnectDelegate?
    public var uRL: NSURL
    public var data: NSData?
    public var object: NSObject
    public var responseString: NSString
    
//    public init(URL: NSURL){
//        self.uRL = URL
//    }
//    public convenience init(URL: NSURL, data: NSData){
//        self.uRL = URL
//        self.data = data
//    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPostRequestJSONData(url: NSURL,data: NSData) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: url)
        request.HTTPBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        return  request
    }
    
    public func setPutRequestJSONData(url: NSURL,data: NSData) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: url)
        request.HTTPBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        request.HTTPMethod = "PUT"
        return  request
    }
    
    public func setGetRequestJSONData(url: NSURL) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: url)
//        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func setGetRequest(url: NSURL) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: url)
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func setUploadImageRequest(uploadurl: NSURL,objImage: UIImage) -> NSMutableURLRequest{
        let url = uploadurl
        let imageData = UIImageJPEGRepresentation(objImage, 0.8)
        print("url request image : \(url)")
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        // Define the multipart request type
        let boundary = "Boundary-\(NSUUID().UUIDString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //requestPost.timeoutInterval = 30
        let fileName = "\(objImage)upload001.jpg"
        let mimeType = "image/jpg"
        
        // Define the data post parameter
        let body = NSMutableData()
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        return request
    }
    
    public func setUploadVideoRequest(uploadurl: NSURL,movieData: NSData) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: uploadurl)
        let boundary = "Boundary-\(NSUUID().UUIDString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        //add movie to request
        let fileName = "uploadedVideo.mp4"
        let mimeType = "video/mp4"
        let body = NSMutableData()
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(movieData)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        return request
    }
    
    public func connectHTTP(request: NSMutableURLRequest) -> NSString{
        let urlsession = NSURLSession.sharedSession()
        let session = urlsession.dataTaskWithRequest(request){(data, response, error) in
        guard error == nil && data != nil else {
            print("Connection error = \(error)")
            return
        }
        if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
            print("StatusCode should be 200, but is \(httpStatus.statusCode)")
            print("Response = \(response)")
        }
        self.responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("ResponseString = \(self.responseString)")
        }
        session.resume()
        return self.responseString
    }

}





