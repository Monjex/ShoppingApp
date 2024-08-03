//
//  FavoriteVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 04/08/24.
//

import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var favTblView: UITableView!
    @IBOutlet weak var emptyLbl: UILabel!
    var favCount = ""
    var favItems: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        favTblView.register(FavTVC.loadNib(), forCellReuseIdentifier: "FavTVC")
        favTblView.dataSource = self
        favTblView.delegate = self
        
        if favCount == "0"{
            favTblView.isHidden = true
            emptyLbl.isHidden = false
        }else{
            favTblView.isHidden = false
            emptyLbl.isHidden = true
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // Reload table view and update cart summary when view appears
            favTblView.reloadData()
            //updateCartSummary()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavTVC", for: indexPath) as! FavTVC
        let item = favItems[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    

    
}
