//
//  ViewController.swift
//  CustomHttpHeadersURLProtocolSample
//
//  Created by Takahiro Ooishi on 2015/11/21.
//  Copyright © 2015年 Takahiro Ooishi. All rights reserved.
//

import UIKit
import CustomHttpHeadersURLProtocol

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCustomHttpHeadersURLProtocol()
  }
  
  @IBAction func doRequest() {
    let url = URL(string: "http://0.0.0.0:9292")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(result)
      } else {
        print(error)
      }
    }) 
    task.resume()
  }
  
  fileprivate func setupCustomHttpHeadersURLProtocol() {
    let setupCustomHeaders: CustomHttpHeadersConfig.SetupCustomHeaders = { (request: NSMutableURLRequest) in
      request.addValue("CustomHttpHeadersURLProtocolSample", forHTTPHeaderField: "X-App-Name")
      request.addValue("\(Date().timeIntervalSince1970)", forHTTPHeaderField: "X-Timestamp")
    }
    
    let canHandleRequest: CustomHttpHeadersConfig.CanHandleRequest = { (request: URLRequest) -> Bool in
      guard let scheme = request.url?.scheme else { return false }
      guard let host = request.url?.host else { return false }
      
      if !["http", "https"].contains(scheme) { return false }
      if host == "0.0.0.0" { return true }

      return false
    }
    
    let config = CustomHttpHeadersConfig(setupCustomHeaders: setupCustomHeaders, canHandleRequest: canHandleRequest)
    CustomHttpHeadersURLProtocol.start(config)
  }
}
