//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    @IBOutlet weak var newPostImageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectButton.setTitle("Select Image", for: .normal)
        newPostImageView.image = nil
        captionTextField.text = ""
    }
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        newPostImageView.image = #imageLiteral(resourceName: "ice")
        selectButton.setTitle("", for: .normal)
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let image = newPostImageView.image,
        let caption = captionTextField.text
        else {return}
        if newPostImageView.image != nil && captionTextField.text != "" {
            PostController.sharedInstance.createPostWith(image: image, caption: caption) { (Post) in
                
            }
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
