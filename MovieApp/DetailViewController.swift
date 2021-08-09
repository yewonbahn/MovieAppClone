//
//  DetailViewController.swift
//  MovieApp
//
//  Created by 반예원 on 2021/08/08.
//

import UIKit
import AVKit
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
    var player: AVPlayer?
    @IBOutlet weak var movieContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.font =
                UIFont.systemFont(ofSize: 24,
                                  weight: .medium)
        }
    }
    //메모리에 올리긴했는데 여기서는 실제디바이스 크기가 어떤지는 확인하지 못함
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movieResult?.trackName
        descriptionLabel.text = movieResult?.longDescription
       

}
        // Do any additional setup after loading the view.
    
    override func viewDidAppear(_ animated: Bool) {
        if let hasURL = movieResult?.previewUrl
        {
            makePlayerAndPlay(urlString: hasURL)
    }
    }
    func makePlayerAndPlay(urlString: String) {
        if let hasUrl = URL(string: urlString){
            self.player = AVPlayer(url: hasUrl)
            let playerLayer = AVPlayerLayer(player: player)
            
            movieContainer.layer.addSublayer(playerLayer)
            playerLayer.frame = movieContainer.bounds
            self.player?.play()
        }
  
    }
    @IBAction func play(_ sender: Any) {
        
        self.player?.play()
    }
    @IBAction func stop(_ sender: Any) {
        self.player?.pause()
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
