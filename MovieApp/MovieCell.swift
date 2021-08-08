 //
//  MovieCell.swift
//  MovieApp
//
//  Created by User on 2021/08/04.
//

import UIKit

class MovieCell: UITableViewCell{
    
    @IBOutlet weak var priceLabel: UILabel!{
        didSet{
            priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        
        didSet{
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        }   
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet{
            dateLabel.font = .systemFont(ofSize: 13, weight: .light)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    {didSet{
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .light)
    }}
    @IBOutlet weak var movieImageView: UIImageView!
}
