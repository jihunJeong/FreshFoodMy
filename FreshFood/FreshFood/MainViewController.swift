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
    
    let realm = try! Realm()
    lazy var savedDatas = realm.objects(Food.self)
    let formatter = DateFormatter()
    var setDate:Date = Date()

    @IBOutlet weak var selectControl: UISegmentedControl!
    @IBOutlet weak var limitTableView: UITableView!
    @IBOutlet weak var locationTableView: UITableView!
    
//    weak var delegate:MainViewControllerDelegate?
    
    let locations = ["냉장고","냉동고","김치냉장고","기타"]
    
    override func viewDidLoad() {
        let tempData = Array(savedDatas)
        
        super.viewDidLoad()
//        formatter.dateFormat = "yyyy.MM.dd"
        selectControl.removeAllSegments()
        for location in locations {
            selectControl.insertSegment(withTitle: location, at: locations.count, animated: false)
        }
        selectControl.selectedSegmentIndex = 0
        print("viedidload")
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
//        limitTableView.delegate = self
//        limitTableView.dataSource = self
        self.locationTableView.register(MainLocationTableViewCell.self, forCellReuseIdentifier: "MainLocationCell")
//        self.limitTableView.register(MainLimitTableViewCell.self, forCellReuseIdentifier: "MainLimitCell")
//
//        self.delegate?.pushData(location: locations[selectControl.selectedSegmentIndex])
        
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("실행")
        let tempData = Array(savedDatas)
        if tableView == locationTableView{
            let dataLocation = locations[selectControl.selectedSegmentIndex]
            let tempData = tempData.filter{$0.location == dataLocation}
            return tempData.count
        }
        else{
            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == locationTableView{
            print("djfsdjfsk")
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MainLocationCell",for:indexPath) as! MainLocationTableViewCell
            let dataLocation = locations[selectControl.selectedSegmentIndex]
            let tempData = Array(savedDatas)
            let temp = tempData.filter{$0.location == dataLocation}
            myCell.mainLocationNameLabel?.text = temp[indexPath.row].name
            myCell.mainLocationQuantityLabel?.text = String(temp[indexPath.row].quantity)
            print("check==========")
            print(tempData)
            return myCell

        }
        else{
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MainLimitCell",for:indexPath) as! MainLimitTableViewCell
            return myCell

        }
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
