//
//  ViewController.swift
//  To_Do_List
//
//  Created by adrewno1 on 11/29/16.
//  Copyright © 2016 adrewno1. All rights reserved.
//


import UIKit
import AKPickerView_Swift
import RAReorderableLayout


class ViewController: UIViewController, AKPickerViewDelegate, AKPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,RAReorderableLayoutDelegate, RAReorderableLayoutDataSource {

    var pickerView: AKPickerView!
    var lists : [String] = []
    var lists2 : [String: [String]] = [ : ]
    @IBOutlet var collectionView: UICollectionView!
    var reminders : [String] = []
    var completed : [String] = []
    var userDefaults = UserDefaults()
    var currentList = ""
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var pickerViewFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pickerView = AKPickerView(frame: pickerViewFrame.frame)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        let newLayout = RAReorderableLayout()
        collectionView!.collectionViewLayout = newLayout
        collectionView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, 0, 0)
        
        if userDefaults.object(forKey: "lists2") != nil
        {
            
            lists2 = userDefaults.object(forKey: "lists2") as! [String: [String]]
            lists2.removeValue(forKey: "")

            reminders = (userDefaults.object(forKey: "lists2") as! [String: [String]]).first!.value
            print(reminders)
            

            print(Array((userDefaults.object(forKey: "lists2") as! [String: [String]]).keys))
        }

        
        

        
        self.view.addSubview(pickerView)
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 45)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 45)!
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.maskDisabled = false
        self.pickerView.interitemSpacing = 25
        self.pickerView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = UIScreen.main.bounds.width
        let threePiecesWidth = floor(screenWidth / 3.0 - ((2.0 / 3) * 2))
        return CGSize(width: threePiecesWidth, height: threePiecesWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pickerView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return Array(lists2.keys).count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return Array(lists2.keys)[item]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomViewCell
        cell.label.text! = reminders[indexPath.row]
        cell.label.preferredMaxLayoutWidth = view.frame.width / 3 - 18

        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, at atIndexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        var text : String
        text = reminders[atIndexPath.row]
        reminders.remove(at: atIndexPath.row)
        reminders.insert(text, at: toIndexPath.row)
        lists2[currentList]! = reminders
        userDefaults.set(lists2, forKey: "lists2")
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int)
    {
        currentList = Array(lists2.keys)[item]
        reminders = lists2[currentList]!
        userDefaults.set(lists2, forKey: "lists2")
        collectionView.reloadData()
        
        
        
    }

    @IBAction func newListAction(_ sender: AnyObject)
    {
        let alert = UIAlertController(title: "New List", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Named"
        }
        let alertAction = UIAlertAction(title: "Okay", style: .default) { (alertAction:UIAlertAction) in
            
           if (alert.textFields![0].text) != nil
            {
                self.lists2[alert.textFields![0].text!] = [ ]
                self.pickerView.reloadData()
                if self.addButton.isEnabled == false
                {
                    self.addButton.isEnabled = !self.addButton.isEnabled
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    
    @IBAction func addCell(_ sender: AnyObject)
    {
        
        let alert = UIAlertController(title: "New Reminder", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (alertAction:UIAlertAction) in
            
            self.reminders.append(alert.textFields![0].text!)
            self.lists2[self.currentList] = self.reminders
            self.userDefaults.set(self.lists2, forKey: "lists2")
            self.collectionView.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (alert:UIAlertAction) in
            
            self.reminders.remove(at: indexPath.row)
            self.lists2[self.currentList] = self.reminders
            self.userDefaults.set(self.lists2, forKey: "lists2")
            self.collectionView.reloadData()

            
        }))
        
        alert.addAction(UIAlertAction(title: "Complete", style: .default, handler: { (alert:UIAlertAction) in
            
            self.completed.append(self.reminders.remove(at: indexPath.row))
            self.lists2["completed"] = self.completed
            self.userDefaults.set(self.lists2, forKey: "lists2")
            self.collectionView.reloadData()
            
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
}

