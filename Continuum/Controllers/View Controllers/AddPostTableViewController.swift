//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/9/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, PhotoSelectorViewControllerDelegate {
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = ""
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        if selectedImage == nil {
            missingItemAlert(string: "photo")
        } else if captionTextField.text == ""{
            missingItemAlert(string: "caption")
        } else if let image = selectedImage, let caption = captionTextField.text {
            PostController.sharedInstance.createPostWith(image: image, caption: caption) { (Post) in
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 0
                }
            }
        } else {
            return
        }
    }
    
    func missingItemAlert(string: String) {
        let missingAlert = UIAlertController(title: "Uh Oh 🙃", message: "Looks like we're missing a \(string), please add one before continuing", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        missingAlert.addAction(dismissAction)
        present(missingAlert, animated: true, completion: nil)
    }
    
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSelectionSegue" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
        }
    }
}
