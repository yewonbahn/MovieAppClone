//
//  ViewController.swift
//  MovieApp
//
//  Created by User on 2021/08/04.
//

import UIKit

class ViewController: UIViewController {
    var movieModel : MovieModel?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
        requestMovieAPI()
    }
// network
    func requestMovieAPI(){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        var components = URLComponents(string: "https://itunes.apple.com/search")
        let term = URLQueryItem(name: "term", value: "marvel")
        let media = URLQueryItem (name:"media",value:"movie")
        
        components?.queryItems =  [term, media]
        
        guard let url = components?.url else {
            return
        }
        var request = URLRequest(url : url )
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) {(data, response, error) in
            print((response as! HTTPURLResponse).statusCode)
            // statusCode 는 모든 개발자가 알아야한다.
            // http statuscode : 꼭 공부하자!!
            // 200 데이터 원하는대로 잘준다!
            // 300 은 페이지가 다른곳으로 넘어가졌다.
            // 400,500 -> 보통 error  내가 잘못한경우 or 네트워크가 아예 문제
            // 다 외울 필요는 없다
            
            // 인코당 디코딩도 다알도록..!
            if let hasData = data {
                do{
                    self.movieModel = try  JSONDecoder().decode(MovieModel.self, from: hasData)
                    print(self.movieModel ?? "no data")
                     
                    self.movieTableView.reloadData()
                }
            catch{
                print(error)
            }
            }
        
        }
        
    
        
        task.resume()
        session.finishTasksAndInvalidate()
        
    }

}
extension ViewController:
    UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieModel?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.titleLabel.text = self.movieModel?.results[indexPath.row].trackName
        return cell
    }
    
    
    
}
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

