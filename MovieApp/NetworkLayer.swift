//
//  NetworkLayer.swift
//  MovieApp
//
//  Created by User on 2021/08/11.
//

import Foundation

enum MovieAPIType{
    case justURL(urlString: String)
    case searchMovie(querys: [URLQueryItem])
}
enum MovieAPIError: Error{
    case badURL
}

class NetworkLayer {
// only url
// url + param
    
    typealias  NetworkCompletion  = (_ data: Data?,_ response: URLResponse?, _ error: Error?) -> Void
    func request(type: MovieAPIType, completion: @escaping NetworkCompletion){
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        //이게안되면 캐치로간다.
        do{
            let request = try buildRequest(type: type)
            
            session.dataTask(with: request) { (data, response, error) in
                print((response as! HTTPURLResponse).statusCode)
                completion(data, response, error)
                
        
                }.resume()
                session.finishTasksAndInvalidate()
        }catch{
            print(error)
            
        }

    }
    private func buildRequest(type: MovieAPIType) throws -> URLRequest{
        switch type {
        case .justURL(urlString: let urlString):
            guard let hasURL = URL(string:   urlString)else{
                throw MovieAPIError.badURL
                
            }
                var request = URLRequest(url : hasURL )
                request.httpMethod = "GET"
                return request
    
        case .searchMovie(querys:let querys):

            var components = URLComponents(string: "https://itunes.apple.com/search")
       
            components?.queryItems = querys
    
            guard let hasUrl = components?.url  else{
                throw MovieAPIError.badURL
            }
            var request = URLRequest(url : hasUrl )
            request.httpMethod = "GET"
            return request
            }

        }
}
