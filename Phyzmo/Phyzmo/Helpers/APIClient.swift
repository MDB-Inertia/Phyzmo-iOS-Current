//
//  APIClient.swift
//  Phyzmo
//
//  Created by Patrick Yin on 11/2/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//
import Foundation
import UIKit

class APIClient {
    static func getAllPositionCV(videoPath: String, completion: @escaping ([String:Any]) -> ()) {
        let requestURL = "https://us-central1-phyzmo.cloudfunctions.net/position-cv-all-saver?uri=" + videoPath
        guard let url = URL(string: requestURL) else {return}
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 540.0
        let task = URLSession(configuration: sessionConfig).dataTask(with: url) { (data, response, error) in
        print("data", data)
        print("response", response)
        print("error", error)
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                let result = jsonResponse as! [String : Any]
                print("result", result)

                completion(result)
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }

    static func getObjectData(objectsDataUri: String, obj_descriptions: [String], line: [CGPoint], unit: Float, max_coor: [CGFloat], completion: @escaping ([String:Any]) -> ()) {
        //ref_list hard coded for now
        print("function started")
        print("line", line)
        print("unit", unit)
        let ref_list = [[line[0].x/max_coor[0], line[0].y/max_coor[1]], [line[1].x/max_coor[0], line[1].y/max_coor[1]], unit] as [Any]
            //[[0.121,0.215],[0.9645,0.446], 0.60] as [Any]

        let request = "objectsDataUri=\(objectsDataUri)&obj_descriptions=\("\(obj_descriptions)".replacingOccurrences(of: "&", with: "%26"))&ref_list=\(ref_list)"
        var requestURL = "https://us-central1-phyzmo.cloudfunctions.net/data-computation?\(request)"
        requestURL = requestURL.replacingOccurrences(of: "\"", with: "\'")
        requestURL = requestURL.replacingOccurrences(of: "[", with: "%5B")
        requestURL = requestURL.replacingOccurrences(of: "]", with: "%5D")
        requestURL = requestURL.replacingOccurrences(of: " ", with: "%20")
        //requestURL = requestURL.replacingOccurrences(of: "&", with: "%26")
        print(requestURL)
        guard let url = URL(string: requestURL) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                let result = jsonResponse as! [String : Any]

                completion(result)
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
        print("function end")
    }
    static func getExistingVidData(id: String, completion: @escaping ([String:Any]) -> ()){
        let requestURL = "https://storage.googleapis.com/phyzmo-videos/\(id).json"
        guard let url = URL(string: requestURL) else {return}

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("data", data)
            print("response", response)
            print("error", error)
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                let result = jsonResponse as! [String : Any]
                print("result", result)

                completion(result)
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
   }
}
