//
//  CartTVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 04/08/24.
//

import UIKit

class CartTVC: UITableViewCell {

    @IBOutlet weak var mainItemView: UIView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var totalItemPriceLbl: UILabel!
    
    @IBOutlet weak var minusItemBtn: UIButton!
    @IBOutlet weak var addItemBtn: UIButton!
    
    var quantity: Int = 1 {
            didSet {
                quantityLbl.text = "\(quantity)"
                updateTotalItemPrice()
            }
        }
    
    var itemPrice: Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set corner radius
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
        UINib(nibName: "CartTVC", bundle: .main)
    }
    
    func configure(with item: Item) {
            nameLbl.text = item.name
            itemPrice = item.price
            priceLbl.text = "₹\(itemPrice)"
            quantity = 1
            updateTotalItemPrice()
            
            if let urlString = item.icon, let url = URL(string: urlString) {
                loadImage(from: url)
            } else {
                itemImgView.image = UIImage(systemName: "photo")
            }
    }
        
    func updateTotalItemPrice() {
            if let quantityText = quantityLbl.text, let quantity = Int(quantityText) {
                let totalPrice = itemPrice * Double(quantity)
                totalItemPriceLbl.text = String(format: "₹%.2f", totalPrice)
            }
        }
    
    @IBAction func minusItemAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.minusItemBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.minusItemBtn.transform = CGAffineTransform.identity
            }
        }
    }
    
    @IBAction func addItemAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.addItemBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.addItemBtn.transform = CGAffineTransform.identity
            }
        }
        
    }
    
}
