//
//  DetailViewController.swift
//  MovieApp
//
//  Created by 반예원 on 2021/08/08.
//

import UIKit

class DetailViewController: UIViewController {

    var movieResult: MovieResult?{
        //값을 넣었다라는 상태!
        didSet{
         
            
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.font = .systemFont(ofSize: 16, weight: .light)
        }
    }
    @IBOutlet weak var movieContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.font =
                UIFont.systemFont(ofSize: 24,
                                  weight: .medium)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movieResult?.trackName
        descriptionLabel.text = movieResult?.longDescription
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
