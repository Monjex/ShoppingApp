//
//  FavTVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 04/08/24.
//

import UIKit

class FavTVC: UITableViewCell {

    @IBOutlet weak var mainItemView: UIView!
    @IBOutlet weak var favImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var itemPrice: Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainItemView.layer.cornerRadius = 8
        mainItemView.layer.masksToBounds = false // Important for shadow
        
        //Set shadow
        mainItemView.layer.shadowColor = UIColor.black.cgColor
        mainItemView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainItemView.layer.shadowOpacity = 0.2
        mainItemView.layer.shadowRadius = 4
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "FavTVC", bundle: .main)
    }
    
    func configure(with item: Item) {
            nameLbl.text = item.name
            itemPrice = item.price
            priceLbl.text = "₹\(itemPrice)"
            
            if let urlString = item.icon, let url = URL(string: urlString) {
                loadImage(from: url)
            } else {
                favImgView.image = UIImage(systemName: "photo")
            }
    }
    
}

extension FavTVC {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to load image: \(error)")
                DispatchQueue.main.async {
                    self?.favImgView.image = UIImage(systemName: "photo")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.favImgView.image = UIImage(systemName: "photo")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.favImgView.image = image
            }
        }
        task.resume()
    }
}
