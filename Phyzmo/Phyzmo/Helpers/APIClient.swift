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

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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

    static func getObjectData(objectsDataUri: String, obj_descriptions: [String], completion: @escaping ([String:Any]) -> ()) {
        //ref_list hard coded for now
        print("function started")
        let ref_list = [[0.121,0.215],[0.9645,0.446], 0.60] as [Any]

        let request = "objectsDataUri=\(objectsDataUri)&obj_descriptions=\(obj_descriptions)&ref_list=\(ref_list)"
        var requestURL = "https://us-central1-phyzmo.cloudfunctions.net/data-computation?\(request)"
        requestURL = requestURL.replacingOccurrences(of: "\"", with: "\'")
        requestURL = requestURL.replacingOccurrences(of: "[", with: "%5B")
        requestURL = requestURL.replacingOccurrences(of: "]", with: "%5D")
        requestURL = requestURL.replacingOccurrences(of: " ", with: "")

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
    }
}
