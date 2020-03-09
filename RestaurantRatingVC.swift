//
//  RestaurantRatingVC.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/1/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class RestaurantRatingVC : UIViewController, UITextFieldDelegate {
    
    var store = RatingStore.sharedInstnce
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var feedbackTextField: UITextField!
    @IBOutlet var myRatingButtons: [UIButton]!
    
    var tagValues = Int()
    
    @IBAction func RatingButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        for button in myRatingButtons {
            if button.tag <= tag {
                button.setTitle("★", for: .normal)
            } else {
                button.setTitle("☆", for: .normal)
            }
        }
        tagValues = tag
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if Reach.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "No WiFi Connection", message: "Please turn on the the WiFi to rate the restaurant", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancel)
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if userNameTextField.text != "" && restaurantNameTextField.text != ""
            && feedbackTextField.text != "" {
            if let username = userNameTextField.text {
                if let resname = restaurantNameTextField.text {
                    if let feedback = feedbackTextField.text {
                            let newRating = Rating(uname: username,
                                                    rname: resname,
                                                    feedback: feedback,
                                                    rating: tagValues)
                            self.saveData(value: newRating)
                            let alert = UIAlertController(title: "Success", message: "Your rating and review has been posted successfully", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        
                        }
                    }
                }
            }
        }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        return (url!.appendingPathComponent("Data").path)
    }
    
    private func saveData(value: Rating) {
        self.store.ratings.append(value)
        NSKeyedArchiver.archiveRootObject(self.store.ratings, toFile: filePath)
    }
    
    private func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Rating] {
            self.store.ratings = ourData
        }
    }
}
