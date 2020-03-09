//
//  MakeBookingViewController.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class MakeBookingViewController: UIViewController, UITextFieldDelegate {
    
    var store = DataStore.sharedInstnce
    
    var seatingCapacity = String()
    var restaurantNames = String()
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var seatsRequiredText: UITextField!
    @IBOutlet weak var arrivalDateTextField: UITextField!
    @IBOutlet weak var arrivalTimeText: UITextField!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var seatingCapaticyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantNameLabel.text = restaurantNames
        self.seatingCapaticyLabel.text = seatingCapacity
        self.seatsRequiredText.delegate = self
        loadData()
        print(seatingCapacity)
        print(restaurantNames)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(MakeBookingViewController.datePickerValueChanged(sender:)),
                             for: UIControlEvents.valueChanged)
        arrivalDateTextField.inputView = datePicker
        
        let datePickerTime = UIDatePicker()
        datePickerTime.datePickerMode = UIDatePickerMode.time
        datePickerTime.addTarget(self, action: #selector(MakeBookingViewController.datPickerValueChangedforTime(sender:)),
                                 for: UIControlEvents.valueChanged)
        arrivalTimeText.inputView=datePickerTime
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reach.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "No WiFi Connection", message: "Please turn on the the WiFi to make bookings", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancel)
            present(controller, animated: true, completion: nil)
        }
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        arrivalDateTextField.text = formatter.string(from: sender.date)
    }
    
    func datPickerValueChangedforTime(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.none
        timeFormatter.timeStyle = DateFormatter.Style.short
        arrivalTimeText.text = timeFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @IBAction func makeBooking(_ sender: Any) {
        if usernameText.text != "" && seatsRequiredText.text != ""
            && arrivalTimeText.text != "" && arrivalDateTextField.text != "" {
            if let username = usernameText.text {
                if let seatsbooked = seatsRequiredText.text {
                    if let arrivaltiming  = arrivalTimeText.text {
                        if let date = arrivalDateTextField.text {
                                if seatsRequiredText.text! <= seatingCapacity {
                                    let newBooking = Booking(uname: username, rname: restaurantNames, time: arrivaltiming, seats: seatsbooked, arrivalDate: date)
                                        self.saveData(value: newBooking)
                                        let alert = UIAlertController(title: "Seats reserved successfully", message: "Please arrive your booking time. We feel great to serve you !", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    } else {
                                let alert = UIAlertController(title: "Exceeded Seat Capacity", message: "Please make booking with in the seat capacity", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Cannot Make Booking", message: "Please try again to make booking", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        return (url!.appendingPathComponent("Data").path)

    }
    
    func checkFileExist() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let checkurl = NSURL(fileURLWithPath: path)
        let filePath = checkurl.appendingPathComponent("Data")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            print("File is available")
        } else {
            print("File isn't available")
        }
    }
    
    private func saveData(value: Booking) {
        self.store.restaurantBookings.append(value)
        NSKeyedArchiver.archiveRootObject(self.store.restaurantBookings, toFile: filePath)
    }
    
    private func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Booking] {
            self.store.restaurantBookings = ourData
        }
    }
}
