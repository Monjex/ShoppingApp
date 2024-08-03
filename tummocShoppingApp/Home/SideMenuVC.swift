//
//  SideMenuVC.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 04/08/24.
//

import UIKit

class SideMenuVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        view.backgroundColor = .white
        
        // Add corner radius to top-right and bottom-right corners
        let cornerRadius: CGFloat = 44
        let path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        
        // Create and configure the UIImageView for profile photo
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "Profile") // Replace with your image name
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the profile image view to the view hierarchy
        view.addSubview(profileImageView)
        
        // Apply constraints to the profile image view
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100), // Adjust width
            profileImageView.heightAnchor.constraint(equalToConstant: 100) // Adjust height
        ])
        
        // Make the UIImageView circular
        profileImageView.layer.cornerRadius = 50 // Half of the width/height
        
        // Create and configure the UILabel for the name
        let nameLabel = UILabel()
        nameLabel.text = "Mohit Singh" // Replace with actual name
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the name label to the view hierarchy
        view.addSubview(nameLabel)
        
        // Apply constraints to the name label
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Create and configure the UILabel for the email
        let emailLabel = UILabel()
        emailLabel.text = "cse.engineermohit@gmail.com" // Replace with actual email
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.textColor = .gray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the email label to the view hierarchy
        view.addSubview(emailLabel)
        
        // Apply constraints to the email label
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Create and configure the UIStackView for menu items
        let menuStackView = UIStackView()
        menuStackView.axis = .vertical
        menuStackView.alignment = .leading
        menuStackView.spacing = 20
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Define the menu items and corresponding system images
        let menuItems = [
            ("Home", "house"),
            ("Orders", "cart"),
            ("Cart", "bag"),
            ("Favorites", "heart"),
            ("Settings", "gear"),
            ("Logout", "power")
        ]
        
        // Create menu items
        for (title, systemImageName) in menuItems {
            let itemStackView = UIStackView()
            itemStackView.axis = .horizontal
            itemStackView.spacing = 10
            itemStackView.alignment = .center
            
            let menuItemIcon = UIImageView()
            menuItemIcon.image = UIImage(systemName: systemImageName)
            menuItemIcon.contentMode = .scaleAspectFit
            menuItemIcon.tintColor = .black
            menuItemIcon.translatesAutoresizingMaskIntoConstraints = false
            
            // Set the width and height for the image view
            menuItemIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
            menuItemIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            let menuItemLabel = UILabel()
            menuItemLabel.text = title
            menuItemLabel.font = UIFont.systemFont(ofSize: 16)
            
            // Add the icon and label to the item stack view
            itemStackView.addArrangedSubview(menuItemIcon)
            itemStackView.addArrangedSubview(menuItemLabel)
            
            // Add the item stack view to the menu stack view
            menuStackView.addArrangedSubview(itemStackView)
        }
        
        // Add the stack view to the view hierarchy
        view.addSubview(menuStackView)
        
        // Apply constraints to the stack view
        NSLayoutConstraint.activate([
            menuStackView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 40),
            menuStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the mask path when the view's bounds change
        let cornerRadius: CGFloat = 44
        let path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
}
