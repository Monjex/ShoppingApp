//
//  ProductsTVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 03/08/24.
//

import UIKit

class ProductsTVC: UITableViewCell {
    
    @IBOutlet weak var productTypeLbl: UILabel!
    @IBOutlet weak var expandCollapseBtn: UIButton!
    @IBOutlet weak var productsColView: UICollectionView! {
        didSet {
            productsColView.delegate = self
            productsColView.dataSource = self
            productsColView.register(ProductsCVC.loadNib(), forCellWithReuseIdentifier: "ProductsCVC")
        }
    }

    var items: [Item] = []
    var isCollapsed: Bool = false
    weak var delegate: ProductsCVCDelegate?

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        class func loadNib() -> UINib? {
            UINib(nibName: "ProductsTVC", bundle: .main)
        }
    
    func configure(with category: Category) {
        productTypeLbl.text = category.name
        // Convert to array and sort by ID
        items = (category.items?.allObjects as? [Item]) ?? []
        items.sort { $0.id < $1.id } // Sort items by ID in ascending order
        
        productsColView.reloadData() // Reload collection view with ordered items
        updateCollectionViewVisibility()
    }


        @IBAction func expandCollapseBtnTapped(_ sender: UIButton) {
            isCollapsed.toggle()
            updateCollectionViewVisibility()
            
            if !isCollapsed {
                UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                    self.expandCollapseBtn.transform = CGAffineTransform(rotationAngle: 3.14/180.0)
                })
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                    self.expandCollapseBtn.transform = CGAffineTransform(rotationAngle: -90.0 * 3.14/180.0)
                })
            }
    }

    private func updateCollectionViewVisibility() {
        UIView.animate(withDuration: 0.2) {
            self.productsColView.alpha = self.isCollapsed ? 0 : 1
            self.productsColView.layoutIfNeeded()
        }
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

extension ProductsTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCVC", for: indexPath) as? ProductsCVC else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.item]
        cell.configure(with: item)
        cell.delegate = delegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let productsCVC = cell as? ProductsCVC {
            let category = items[indexPath.item]
            productsCVC.configure(with: category)
            productsCVC.delegate = delegate
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 200, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
