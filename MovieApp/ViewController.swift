//
//  ViewController.swift
//  MovieApp
//
//  Created by User on 2021/08/04.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    var movieModel : MovieModel?
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    var networkLayer = NetworkLayer()
    
        
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
        requestMovieAPI()
    }
    // completion은 어떤것에대한 동작들이 최종적으로 완료되었을때 실행되는 느낌으로 사용
    // 타입은 클로져 타입 (클로져 타입을 받아야되기 때문에)
//    func loadImage(urlString: String, completion: @escaping(UIImage?) -> Void){
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//        if let hasURL = URL(string: urlString)
//        {
//            var request = URLRequest(url : hasURL )
//            request.httpMethod = "GET"
//
//            session.dataTask(with: request) { (data, response, error) in
//                print((response as! HTTPURLResponse).statusCode)
//                //메인쓰레드에서 쭉 생성된 기본 상태의 로직에서만 쭉 로직이 순차적으로만 진행되고
//                //보장됐을때만 작동한다.
//                //그럼 어떻게?
//
//                //클로져는 escaping 이란 개념이 있다.
//                //클로져에서 리턴받은 데이터는 이 값의 생명주기는, 여기서 밖으로 나가면 없어진다
//                //괄호안에서만 살아있다. 밖으로 나가서 전달하고 싶다면?
//                //Escaping : 계속 유지를 하겟다. 타입앞에다가 선언
//                if let hasData = data{
//
//                    completion(UIImage(data: hasData))
//                    return
//                }
//
//            }.resume()
//            session.finishTasksAndInvalidate()
//        }
//
//        completion(nil)
//
//    }
    func loadImage(urlString: String, completion: @escaping(UIImage?) -> Void){
        networkLayer.request(type: .justURL(urlString: urlString)) { (data, response, error) in
            if let hasData = data{
                completion(UIImage(data: hasData))
                    return
                        }
            completion(nil)
        }
        
    }
    
    
// network
    
    
    func requestMovieAPI(){
        
        let term = URLQueryItem(name: "term", value: "marvel")
        let media = URLQueryItem (name:"media",value:"movie")
        let querys = [term, media]
        
        
        networkLayer.request(type: .searchMovie(querys: querys)) { (data, response, error) in
            
            if let hasData = data {
                do{
                    self.movieModel = try  JSONDecoder().decode(MovieModel.self, from: hasData)
                    print(self.movieModel ?? "no data")
                    DispatchQueue.main.async {
                       self.movieTableView.reloadData()
                    }
                   
                }
            catch{
                print(error)
            }
            }
            
        }
        
        
    }
//    func requestMovieAPI(){
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//
//        var components = URLComponents(string:"https://itunes.apple.com/search")
//        let term = URLQueryItem(name: "term", value: "marvel")
//        let media = URLQueryItem (name:"media",value:"movie")
//
//        components?.queryItems =  [term, media]
//
//        guard let url = components?.url else {
//            return
//        }
//        var request = URLRequest(url : url )
//        request.httpMethod = "GET"
//
//        let task = session.dataTask(with: request) {(data, response, error) in
//            print((response as! HTTPURLResponse).statusCode)
//            // statusCode 는 모든 개발자가 알아야한다.
//            // http statuscode : 꼭 공부하자!!
//            // 200 데이터 원하는대로 잘준다!
//            // 300 은 페이지가 다른곳으로 넘어가졌다.
//            // 400,500 -> 보통 error  내가 잘못한경우 or 네트워크가 아예 문제
//            // 다 외울 필요는 없다
//
//            // 인코당 디코딩도 다알도록..!
//            if let hasData = data {
//                do{
//                    self.movieModel = try  JSONDecoder().decode(MovieModel.self, from: hasData)
//                    print(self.movieModel ?? "no data")
//                    DispatchQueue.main.async {
//                       self.movieTableView.reloadData()
//                    }
//
//                }
//            catch{
//                print(error)
//            }
//            }
//
//        }
//
//
//
//        task.resume()
//        session.finishTasksAndInvalidate()
//
//    }

}
extension ViewController:
    UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieModel?.results.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name:"DetailViewController" ,bundle:nil).instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        //내가 고른 쉘 색상이 자연스레 사라짐.
        tableView.deselectRow(at: indexPath, animated: true)
        detailVC.movieResult = self.movieModel?.results[indexPath.row]
      //  detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true){
            
        }
        
    }
    //  컨텐츠 내용만큼 높이를 지정하겠다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.titleLabel.text = self.movieModel?.results[indexPath.row].trackName
        cell.descriptionLabel.text = self.movieModel?.results[indexPath.row].shortDescription
        
        
        let currency = self.movieModel?.results[indexPath.row].currency ?? ""
        let price = self.movieModel?.results[indexPath.row].trackPrice?.description ?? ""
        cell.priceLabel.text = currency + price
        
        
        if let hasURL = self.movieModel?.results[indexPath.row].image{            self.loadImage(urlString: hasURL) { image in
            DispatchQueue.main.async {
                cell.movieImageView.image = image
            }
        }
    }
        if let dateString = self.movieModel?.results[indexPath.row].releaseDate
        {
            let formatter = ISO8601DateFormatter()
            if let isoDate = formatter.date(from: dateString){
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "yyyy년 MM월 dd일"
                let dateString = myFormatter.string(from: isoDate)
                
                cell.dateLabel.text = dateString
            }
        
        }
      
        
        
        return cell
    }
    
    
    
}
extension ViewController: UISearchBarDelegate{
    //search 눌렀을때 호출되는 함수.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  
    }
    
}

