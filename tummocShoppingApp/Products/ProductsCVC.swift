//
//  ProductsCVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 03/08/24.
//

import UIKit

// Define the delegate protocol
protocol ProductsCVCDelegate: AnyObject {
    func addItemToCart(for itemName: String)
    func removeItemFromCart(for itemName: String)
    func isItemInCart(itemName: String) -> Bool
    
    func addItemToFav(for itemName: String)
    func removeItemFromFav(for itemName: String)
    func isItemInFav(itemName: String) -> Bool

}

class ProductsCVC: UICollectionViewCell {

    @IBOutlet weak var productMainView: UIView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    weak var delegate: ProductsCVCDelegate?
    private var itemName: String?
        
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Set corner radius
            productMainView.layer.cornerRadius = 8
            productMainView.layer.masksToBounds = false // Important for shadow
            
            // Set shadow
            productMainView.layer.shadowColor = UIColor.black.cgColor
            productMainView.layer.shadowOffset = CGSize(width: 0, height: 2)
            productMainView.layer.shadowOpacity = 0.2
            productMainView.layer.shadowRadius = 4
   
    }

    class func loadNib() -> UINib? {
        UINib(nibName: "ProductsCVC", bundle: .main)
    }

    func configure(with item: Item) {
        itemName = item.name
        itemNameLbl.text = item.name
        priceLbl.text = "₹\(item.price)"
        
        // Check cart state from delegate
        let isAddedToCart = delegate?.isItemInCart(itemName: itemName ?? "") ?? false
        updateCartButtonState(isAddedToCart: isAddedToCart)
        
        let isAddedToFav = delegate?.isItemInFav(itemName: itemName ?? "") ?? false
        updateFavButtonState(isAddedToFav: isAddedToFav)
        
        if let urlString = item.icon, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            itemImgView.image = UIImage(systemName: "photo")
        }
    }

    //Updating BoolValue and Changing image of CartBtn
    func updateCartButtonState(isAddedToCart: Bool) {
        let imageName: String
        let tintColor: UIColor

        if isAddedToCart {
            imageName = "checkmark.square.fill"
            tintColor = .systemGreen
        } else {
            imageName = "plus.square.fill"
            tintColor = .orange
        }

        if let image = UIImage(systemName: imageName) {
            addToCartBtn.setImage(image, for: .normal)
            addToCartBtn.tintColor = tintColor
            
            // Adjust the image size
            if let imageView = addToCartBtn.imageView {
                let scale: CGFloat = 1.5 // Adjust scale factor as needed
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: 24 * scale),
                    imageView.heightAnchor.constraint(equalToConstant: 24 * scale)
                ])
            }
        }
    }
    
    func updateFavButtonState(isAddedToFav: Bool) {
        let imageName: String
        let tintColor: UIColor

        if isAddedToFav {
            imageName = "heart.fill"
            tintColor = .red
        } else {
            imageName = "heart"
            tintColor = .black
        }

        if let image = UIImage(systemName: imageName) {
            favBtn.setImage(image, for: .normal)
            favBtn.tintColor = tintColor
            
            // Adjust the image size
            if let imageView = favBtn.imageView {
                let scale: CGFloat = 1.5 // Adjust scale factor as needed
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: 24 * scale),
                    imageView.heightAnchor.constraint(equalToConstant: 24 * scale)
                ])
            }
        }
    }

    //Loading Image of the Item
    private func loadImage(from url: URL) {
        // Use URLSession to fetch the image data
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Handle errors
            if let error = error {
                print("Failed to load image: \(error)")
                DispatchQueue.main.async {
                    self?.itemImgView.image = UIImage(systemName: "photo")
                }
                return
            }
    
            // Check if data is available
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.itemImgView.image = UIImage(systemName: "photo")
                }
                return
            }
    
            // Update UI on the main thread
            DispatchQueue.main.async {
                self?.itemImgView.image = image
            }
        }
    
        task.resume()
    }
    
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        guard let itemName = itemName else { return }
        
        let isAddedToCart = delegate?.isItemInCart(itemName: itemName) ?? false
        let newState = !isAddedToCart
        
        // Perform zoom-out animation
        UIView.animate(withDuration: 0.2, animations: {
            self.addToCartBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.addToCartBtn.transform = CGAffineTransform.identity
            }
        }
        
        // Update the cart state via the delegate
        if newState {
            delegate?.addItemToCart(for: itemName)
        } else {
            delegate?.removeItemFromCart(for: itemName)
        }
        
        // Update UI based on new state
        updateCartButtonState(isAddedToCart: newState)
        
    }

    @IBAction func addToFavAction(_ sender: UIButton) {
        guard let itemName = itemName else { return }
        
        let isAddedToFav = delegate?.isItemInFav(itemName: itemName) ?? false
        let newState = !isAddedToFav
        
        // Perform zoom-out animation
        UIView.animate(withDuration: 0.2, animations: {
            self.favBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.favBtn.transform = CGAffineTransform.identity
            }
        }
        
        // Update the cart state via the delegate
        if newState {
            delegate?.addItemToFav(for: itemName)
        } else {
            delegate?.removeItemFromFav(for: itemName)
        }
        
        // Update UI based on new state
        updateFavButtonState(isAddedToFav: newState)
        
    }
}
