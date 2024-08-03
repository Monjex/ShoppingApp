//
//  CartVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 04/08/24.
//

import UIKit

class CartVC: UIViewController{
    
    @IBOutlet weak var cartTblView: UITableView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var emptyLbl: UILabel!
    
    var cartItems: [Item] = []
    var cartCount = ""
    var itemQuantities: [Int] = []

        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cartTblView.register(CartTVC.loadNib(), forCellReuseIdentifier: "CartTVC")
        
        cartTblView.delegate = self
        cartTblView.dataSource = self
        
        totalView.layer.cornerRadius = 14
        checkOutBtn.layer.cornerRadius = 4
        
        discountLbl.text = "-20"
        
        //updateCartSummary()
        
        if cartCount == "0"{
            cartTblView.isHidden = true
            totalView.isHidden = true
            checkOutBtn.isHidden = true
            emptyLbl.isHidden = false
        }else{
            cartTblView.isHidden = false
            totalView.isHidden = false
            checkOutBtn.isHidden = false
            emptyLbl.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Reload table view and update cart summary when view appears
        cartTblView.reloadData()
        updateCartSummary()
    }
    
    
    private func updateCartSummary() {
        // Calculate subtotal and total by iterating over visible cells
        let visibleCells = cartTblView.visibleCells as! [CartTVC]
    
        let subtotal = visibleCells.reduce(0.0) { (result, cell) in
            let itemPrice = Double(cell.priceLbl.text?.replacingOccurrences(of: "₹", with: "") ?? "0") ?? 0
            let quantity = Int(cell.quantityLbl.text ?? "1") ?? 1
            return result + itemPrice * Double(quantity)
        }
    
        let discount = Double(discountLbl.text?.replacingOccurrences(of: "-", with: "") ?? "0") ?? 0
        let total = subtotal - discount
    
        subTotalLbl.text = String(format: "₹%.2f", subtotal)
        totalLbl.text = String(format: "₹%.2f", total)
    }
        
    @objc func incrementQuantity(_ sender: UIButton) {
        
        guard let cell = cartTblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CartTVC else { return }
        
        if let quantityText = cell.quantityLbl.text, let quantity = Int(quantityText) {
            let newQuantity = quantity + 1
            cell.quantityLbl.text = "\(newQuantity)"
            cell.updateTotalItemPrice() // Update total item price for the cell
            
            updateCartSummary() // Update cart summary
        }
        
    }
    
    @objc func decrementQuantity(_ sender: UIButton) {
        guard let cell = cartTblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CartTVC else { return }
        
        if let quantityText = cell.quantityLbl.text, let quantity = Int(quantityText), quantity > 1 {
            let newQuantity = quantity - 1
            cell.quantityLbl.text = "\(newQuantity)"
            cell.updateTotalItemPrice() // Update total item price for the cell
            
            updateCartSummary() // Update cart summary
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
 
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVC", for: indexPath) as! CartTVC
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        
        cell.minusItemBtn.tag = indexPath.row
        cell.addItemBtn.tag = indexPath.row
        
        cell.minusItemBtn.addTarget(self, action: #selector(decrementQuantity(_:)), for: .touchUpInside)
        cell.addItemBtn.addTarget(self, action: #selector(incrementQuantity(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension CartTVC {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to load image: \(error)")
                DispatchQueue.main.async {
                    self?.itemImgView.image = UIImage(systemName: "photo")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.itemImgView.image = UIImage(systemName: "photo")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.itemImgView.image = image
            }
        }
        task.resume()
    }
}
