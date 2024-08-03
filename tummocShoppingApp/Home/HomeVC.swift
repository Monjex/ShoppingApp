//
//  HomeVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 03/08/24.
//

import UIKit
import CoreData

class HomeVC: UIViewController{
   
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var homeTblView: UITableView!
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var cartCountLbl: UILabel!
    @IBOutlet weak var favCountLbl: UILabel!
    @IBOutlet weak var sideMenuBtn: UIButton!
    
    //SideMenu
    private let sideMenuViewController = SideMenuVC()
    private var isMenuVisible = false
    private var sideMenuLeadingConstraint: NSLayoutConstraint!
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    //CategoriesBtnView
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
    //StackView for InfoView
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private var infoViewBottomConstraint: NSLayoutConstraint!
    private var productTypes: [String] = []
    private var isInfoViewVisible = false
    
    
    
    // Array to hold categories
    var categories: [Category] = []
    
    //Cart Value
    private var cartCount: Int = 0 {
            didSet {
                updateCartCountLabel()
            }
        }
    
    //Favorite Value
    private var favCount: Int = 0 {
            didSet {
                updateFavCountLabel()
            }
        }
    
    var cartState: [String: Bool] = [:] // Dictionary to track cart state
    var favCartState: [String: Bool] = [:] // Dictionary to track favorite state
    var itemsDictionary: [String: Item] = [:] // Key: itemName, Value: Item
    var cartItems: [Item] = [] //Hold Cart Items
    var favItems: [Item] = [] //Hold Favorite Items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Home Table View
        homeTblView.register(ProductsTVC.loadNib(), forCellReuseIdentifier: "ProductsTVC")
        homeTblView.dataSource = self
        homeTblView.delegate = self
        
        categoriesBtn.layer.cornerRadius = 12
        
        //CategoryView
        setupInfoView()
        
        let cornerRadius = cartCountLbl.frame.size.width / 2
        cartCountLbl.layer.cornerRadius = cornerRadius
        cartCountLbl.layer.masksToBounds = true
        
        favCountLbl.layer.cornerRadius = cornerRadius
        favCountLbl.layer.masksToBounds = true
        
        // Load saved data
        loadSavedData()
        
        // Fetch data from Core Data
        fetchCategories()
        
        print(UserDefaults.standard.integer(forKey: "cartCount"))
        
        applyGradient()
        applyCornerRadius()
        
        //sideMenuCode
        // Set up the main view
        view.backgroundColor = .white
        
        sideMenuBtn.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        
        // Set up the blur effect view
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        
        // Add the side menu as a child view controller
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
        
        // Set up initial side menu position
        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        sideMenuLeadingConstraint = sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -view.frame.width * 0.8)
        
        NSLayoutConstraint.activate([
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            sideMenuLeadingConstraint
        ])
        
        // Add pan gesture recognizer for swipe gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        // Add tap gesture recognizer to close the menu when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }

    //Categories View
    private func setupInfoView() {
        view.addSubview(infoView)
        infoView.addSubview(stackView)
        
        // Set up constraints for infoView and stackView
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 84),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -84),
            stackView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -16)
        ])
        
        // Constraint to position infoView initially below the view
        infoViewBottomConstraint = infoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        infoViewBottomConstraint.isActive = true
    }

    //Gradient on ToolBar
    func applyGradient() {
            // Create a gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = toolBarView.bounds
            
            // Define the colors for the gradient (top red to bottom yellow)
            gradientLayer.colors = [
                UIColor.systemRed.withAlphaComponent(0.0).cgColor,       // Red color at the top
                UIColor.systemYellow.cgColor     // Yellow color at the bottom
            ]
            
            // Define color stops (optional)
            gradientLayer.locations = [0.0, 1.0] // Start with red at the top (0.0) and transition to yellow at the bottom (1.0)
            
            // Set the gradient direction (top to bottom)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Start at the top
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // End at the bottom
            
            // Add the gradient layer to the view
            toolBarView.layer.insertSublayer(gradientLayer, at: 0)
        }
    
     func applyCornerRadius() {
            // Define the radius for bottom-left and bottom-right corners
            let radius: CGFloat = 20.0
            
            // Create a path that defines the rounded corners
            let path = UIBezierPath(roundedRect: toolBarView.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: radius, height: radius))
            
            // Create a shape layer with the path
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            
            // Apply the mask to the view
            toolBarView.layer.mask = maskLayer
        }
    
    //SideMenu Toggle
    @objc private func toggleMenu() {
        animateSideMenu(shouldOpen: !isMenuVisible)
    }

    //Animating Side Menu
    private func animateSideMenu(shouldOpen: Bool) {
        sideMenuLeadingConstraint.constant = shouldOpen ? 0 : -view.frame.width * 0.8
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.blurEffectView.alpha = shouldOpen ? 1 : 0
        }) { (finished) in
            self.isMenuVisible = shouldOpen
        }
    }

    //SideMenu will open even if user swipe from left to right just dont touch on cells as they will scroll swipe on product type like Food, Beverage etc
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)

        switch recognizer.state {
        case .changed:
            if isMenuVisible {
                // For closing: Allow dragging left to close
                sideMenuLeadingConstraint.constant = max(-view.frame.width * 0.8, min(translation.x, 0))
            } else {
                // For opening: Allow dragging right to open
                sideMenuLeadingConstraint.constant = min(0, max(translation.x - view.frame.width * 0.8, -view.frame.width * 0.8))
            }
            self.view.layoutIfNeeded()
        case .ended:
            let shouldOpen = velocity.x > 0
            animateSideMenu(shouldOpen: shouldOpen)
        default:
            break
        }
    }

    //Side Menu will also get closed, if user tap on side menu
    @objc private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if isMenuVisible {
            // Close the menu when tapping outside
            animateSideMenu(shouldOpen: false)
        }
    }
      
    //Fetching Categories
    func fetchCategories() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
    
        categories = CoreDataManager.shared.fetchCategories(context: context)
    
    // Populate items dictionary
        for category in categories {
            if let items = category.items as? Set<Item> {
                for item in items {
                    itemsDictionary[item.name ?? ""] = item
                }
            }
        }
    
        homeTblView.reloadData()
    }

    private func updateCartCountLabel() {
        cartCountLbl.text = "\(cartCount)"
    }
    
    private func updateFavCountLabel() {
        favCountLbl.text = "\(favCount)"
    }
    
    private func loadSavedData() {
        cartCount = UserDefaults.standard.integer(forKey: "cartCount")
        favCount = UserDefaults.standard.integer(forKey: "favCount")
        
        if let savedCartState = UserDefaults.standard.dictionary(forKey: "cartState") as? [String: Bool] {
            cartState = savedCartState
        }
        
        if let savedCartState = UserDefaults.standard.dictionary(forKey: "favCartState") as? [String: Bool] {
            favCartState = savedCartState
        }

        // Reload the table view to ensure proper display
        homeTblView.reloadData()
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartVC = storyboard.instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteVC
        
        cartVC.favItems = favItems
        cartVC.favCount = favCountLbl.text!
        
        navigationController?.pushViewController(cartVC, animated: true)
        
    }
    
    @IBAction func categoriesAction(_ sender: UIButton) {
        
        if isInfoViewVisible {
                hideProductInfo()
            } else {
                productTypes = categories.map { $0.name ?? "Unknown" }
                populateStackView()
                showProductInfo()
            }
            isInfoViewVisible.toggle()
        
        // Perform zoom-out animation
        UIView.animate(withDuration: 0.2, animations: {
            self.categoriesBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.categoriesBtn.transform = CGAffineTransform.identity
            }
        }
    }

    private func populateStackView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear previous labels
    
        for productType in productTypes {
            let label = UILabel()
            label.text = productType
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.numberOfLines = 0
            stackView.addArrangedSubview(label)
        }
    }
    
    //Show Categories View through CategoryBtn
    private func showProductInfo() {
        guard let categoriesBtn = categoriesBtn else { return }
        
        // Update infoViewBottomConstraint to position above categoriesBtn with a 12-point space
        let bottomSpace = -112.0
        let categoriesBtnBottom = categoriesBtn.frame.maxY
        let infoViewHeight = infoView.frame.height
        let infoViewTop = categoriesBtnBottom - infoViewHeight - bottomSpace
        
        // Animate the transition
        UIView.animate(withDuration: 0.3) {
            self.infoViewBottomConstraint.constant = self.view.bounds.height - infoViewHeight - infoViewTop
            self.view.layoutIfNeeded()
        }
    }

    //Hide Categories View through CategoryBtn
    private func hideProductInfo() {
        UIView.animate(withDuration: 0.3, animations: {
            self.infoViewBottomConstraint.constant = 200 // Adjust to hide the view off-screen or below the visible area
            self.view.layoutIfNeeded()
        }) { _ in
            // Additional actions after hiding, if needed
        }
    }
    
    @IBAction func cartAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartVC = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        cartVC.cartItems = cartItems
        cartVC.cartCount = cartCountLbl.text!
        
        navigationController?.pushViewController(cartVC, animated: true)
       
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Since each section will contain a single collection view cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTVC", for: indexPath) as? ProductsTVC else {
            return UITableViewCell()
        }
        let category = categories[indexPath.section]
        cell.configure(with: category)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let productsTVC = cell as? ProductsTVC {
            let category = categories[indexPath.section]
            productsTVC.configure(with: category)
            productsTVC.delegate = self
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath) as? ProductsTVC
        return cell?.isCollapsed == true ? 80 : 300 // Adjust height based on expanded/collapsed state
    }
}

//Delegate work
extension HomeVC: ProductsCVCDelegate {
    func isItemInFav(itemName: String) -> Bool {
        return favCartState[itemName] ?? false
    }
    
    func addItemToFav(for itemName: String) {
      
        favCount += 1
        favCartState[itemName] = true
        // Fetch item by name
            if let item = itemsDictionary[itemName] {
                favItems.append(item)
            }
        
    }
    
    func removeItemFromFav(for itemName: String) {
        // Remove the item from cartItems array
        if favCount > 0 {
            favCount -= 1
            favCartState[itemName] = false
            
            // Remove the item from cartItems array
                    if let index = favItems.firstIndex(where: { $0.name == itemName }) {
                        favItems.remove(at: index)
                    }
        }
    }
    
    func addItemToCart(for itemName: String) {
        cartCount += 1
        cartState[itemName] = true
        // Fetch item by name
            if let item = itemsDictionary[itemName] {
                cartItems.append(item)
            }
    }

    func removeItemFromCart(for itemName: String) {
        if cartCount > 0 {
            cartCount -= 1
            cartState[itemName] = false
            
            // Remove the item from cartItems array
                    if let index = cartItems.firstIndex(where: { $0.name == itemName }) {
                        cartItems.remove(at: index)
                    }
            
        }
    }

    func isItemInCart(itemName: String) -> Bool {
        return cartState[itemName] ?? false
    }
    
}
