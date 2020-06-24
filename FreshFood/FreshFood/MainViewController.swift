//
//  MainViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/23.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var selectControl: UISegmentedControl!
    @IBOutlet weak var limitTableView: UITableView!
    @IBOutlet weak var locationTableView: UITableView!
    
    let realm = try! Realm()
    lazy var savedDatas = realm.objects(Food.self)
    let formatter = DateFormatter()
    var setDate:Date = Date()
    
//    weak var delegate:MainViewControllerDelegate?
    
    let locations = ["냉장고","냉동고","김치냉장고","기타"]
    let today:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        formatter.dateFormat = "yyyy.MM.dd"
        selectControl.removeAllSegments()
        for location in locations {
            selectControl.insertSegment(withTitle: location, at: locations.count, animated: false)
        }
        selectControl.selectedSegmentIndex = 0
        
        locationTableView.delegate = self
        locationTableView.dataSource = self
//        locationTableView.backgroundColor = UIColor(red: 226, green: 237, blue: 190, alpha: 1)
        
        limitTableView.delegate = self
        limitTableView.dataSource = self
        
        self.locationTableView.register(MainLocationTableViewCell.self, forCellReuseIdentifier: "LocationReuseCell")
        
        self.limitTableView.register(MainLimitTableViewCell.self, forCellReuseIdentifier: "LimitCell")
//
//        self.delegate?.pushData(location: locations[selectControl.selectedSegmentIndex])
        
        // Do any additional setup after loading the view.
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tempData = Array(savedDatas)
        if tableView == locationTableView{
            let dataLocation = locations[selectControl.selectedSegmentIndex]
            let tempData = tempData.filter{$0.location == dataLocation}
//            print("tempData.count : \(tempData.count)")
            return tempData.count
        }
        else{
            let tempData = Array(savedDatas)
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            
            var temp = tempData.filter{formatter.string(from:$0.limitDate) == formatter.string(from: today)}
            for i in 1..<3
            {
                let calendar = Calendar.current
                let day = DateComponents(day:i)
                if let date = calendar.date(byAdding: day, to: setDate)
                {
                    let t = tempData.filter{formatter.string(from:$0.limitDate) == formatter.string(from: date)}
                    temp.append(contentsOf: t)
                }
            }
            
            return temp.count
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == locationTableView{
//            print("djfsdjfsk")
            let myCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "LocationReuseCell")
//            let myCell = tableView.dequeueReusableCell(withIdentifier: "LocationReuseCell",for: indexPath) as! UITableViewCell

            
            
            let dataLocation = locations[selectControl.selectedSegmentIndex]
            let tempData = Array(savedDatas)
            let temp = tempData.filter{$0.location == dataLocation}
//            print("type \(type(of: temp[indexPath.row].name))")

            myCell.textLabel?.text = temp[indexPath.row].name
            myCell.detailTextLabel?.text =  String(Int(temp[indexPath.row].quantity))
//            myCell.detailTextLabel?.text = "1"
//            myCell.mainLocationNameLabel?.text = temp[indexPath.row].name
//            myCell.mainLocationQuantityLabel?.text = String(temp[indexPath.row].quantity)
//            print("check==========")
//            print(tempData)
            return myCell

        }
        else{
            let myCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "LimitReuseCell")
            let tempData = Array(savedDatas)
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
                     
            var temp = tempData.filter{formatter.string(from:$0.limitDate) == formatter.string(from: today)}
            for i in 1...3
            {
                let calendar = Calendar.current
                let day = DateComponents(day:i)
                if let date = calendar.date(byAdding: day, to: setDate)
                {
                    let t = tempData.filter{formatter.string(from:$0.limitDate) == formatter.string(from: date)}
                    temp.append(contentsOf: t)
                }
            }
            
            myCell.textLabel?.text = temp[indexPath.row].name
            myCell.detailTextLabel?.text =  formatter.string(from: temp[indexPath.row].limitDate) + "까지"
            return myCell

        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor(red: 226, green: 237, blue: 190, alpha: 1)
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        cell.contentView.backgroundColor = UIColor.clear
        cell.tintColor = UIColor.orange
    }

    @IBAction func segmentSelected(_ sender: Any) {
        locationTableView.reloadData()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
