//
//  Repository.swift
//  ios-repo-app
//
//  Created by Brian Bansenauer on 10/5/19.
//  Copyright © 2019 Cascadia College. All rights reserved.
//
import Foundation
import UIKit
// TODO : Add Repo Protocol to allow for a MockAPIRepo
protocol APIRepository {
   
}

protocol hasID {
     var id: Int?{get set}
 }
// TODO : Use Generics and typeAlias to make the Repository class more general
class Repository<T> where T : Codable, T: hasID  {
    var path: String
    init(withPath path: String){
        self.path = path
    }
    
    
    func fetch(withId id: Int, withCompletion completion: @escaping (T?) -> Void) {
        let URLstring = path + "/id/\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                    if let user = try? JSONDecoder().decode(T.self, from: data!){completion(user)}
                })
                task.resume()
            }
        }
        func create( a:T, withCompletion completion: (User?) -> Void) {
            guard a.id != nil else {return}
            let url = path + "/id/\(a.id!)"
            var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
            postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            postRequest.httpMethod = "POST"
            postRequest.httpBody = try? JSONEncoder().encode(a.self)
            
            let task = URLSession.shared.dataTask(with: postRequest) {
                (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")        }
            task.resume()
        }
        func update( withId id:Int, a:T ) {
            if let url = URL.init(string: path + "\(id)"){
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "PUT"
                urlRequest.httpBody = try? JSONEncoder().encode(a)
                let task = URLSession.shared.dataTask(with: urlRequest)
                task.resume()
            }
        }
        func delete( withId id:Int ) {
            if let url = URL.init(string: path + "\(id)"){
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "DELETE"
                let task = URLSession.shared.dataTask(with: urlRequest)
                task.resume()
            }
        }
    }
}
