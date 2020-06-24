//
//  FoodListViewController.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/21.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift

class FoodListViewController: UIViewController, UISearchResultsUpdating, ModalActionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate : FoodListCellDelegate?
    
    struct DateStruct {
        var string: String = ""
        var leftDate: Double = 0.0
    }
    
    var realm = try! Realm()
    lazy var temp = realm.objects(Food.self).sorted(byKeyPath: "name", ascending: true)
    lazy var temp1 = realm.objects(Food.self).sorted(byKeyPath: "name", ascending: true)
    
    var formatter = DateFormatter()

    var date0: DateStruct = DateStruct(string: "유통기한 지남", leftDate: 0)
    var date1: DateStruct = DateStruct(string: "유통기한 임박", leftDate: 3)
    var date2: DateStruct = DateStruct(string: "유통기한 1주", leftDate: 7)
    var date3: DateStruct = DateStruct(string: "유통기한 2주", leftDate: 14)
    var date4: DateStruct = DateStruct(string: "유통기한 3주", leftDate: 21)
    var date5: DateStruct = DateStruct(string: "유통기한 4주 이상", leftDate: 1000000000000000)
    
    //Order Data Section
    var dateOfSection: [DateStruct] = []
    var initCharacter: [UnicodeScalar] = []
    var foodLocation: [String] = []
    var sortedDateSection: [DateStruct] = []
    var sortByDate: [[Food]] = [[],[],[],[],[],[]]
    var sortedLocationSection: [String] = []
    var sortedLocation: [[Food]] = [[],[],[],[]]
    
    //OrderOption Section
    var orderOption = 1
    
    //Searchbar Section
    var searchActive : Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    var searchController:UISearchController!
    var filtered:[Food] = []
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        searchBar.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //searchController = UISearchController(searchResultsController: nil)
        //searchController.searchResultsUpdater = self
        //searchController.searchBar.sizeToFit()
        //tableView.tableHeaderView = searchController.searchBar

        definesPresentationContext = true
        
        super.viewDidLoad()
        self.updateInformation()
        self.reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateInformation()
        self.reload()
    }
    
    func updateInformation() {
        initCharacter.removeAll()
        sortedDateSection.removeAll()
        sortByDate = [[],[],[],[],[],[]]
        
        let foodList = Array(temp).sorted{ $0.name < $1.name }
    
        dateOfSection = [date0, date1, date2, date3, date4, date5]
        foodLocation = ["냉장고", "냉동고", "김치냉장고", "기타"]
    
        for food in foodList {
            //sort Option by string
            initCharacter.append(splitText(text: food.name))
            
            //sort Option by Date
            for j in 0...dateOfSection.count-1 {
                let interval:Double = dateOfSection[j].leftDate
                var leftinterval:Double = -10000
                if j != 0 {
                    leftinterval = dateOfSection[j-1].leftDate
                }
                if (food.limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < (food.limitDate.timeIntervalSinceNow / 86400) {
                    sortByDate[j].append(food)
                    sortByDate[j].sort{ $0.limitDate < $1.limitDate}
                    if sortedDateSection.contains(where: { $0.string == dateOfSection[j].string }) {
                        continue
                    }
                    sortedDateSection.append(dateOfSection[j])
                }
            }
        
            for j in 0..<foodLocation.count {
                if (food.location == foodLocation[j]) {
                    sortedLocation[j].append(food)
                    if sortedLocationSection.contains(where: { $0 == foodLocation[j]}) {
                        continue
                    }
                    sortedLocationSection.append(foodLocation[j])
                }
            }
        }
        sortedDateSection.sort( by: {$0.leftDate < $1.leftDate})
        
        tableView.dataSource = self
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    //첫 자음을 얻는 함수
    func splitText(text: String) -> UnicodeScalar{
        let text = text.first

        let val = (UnicodeScalar(String(text!))?.value)!
           
        var s = (val - 0xac00) / 28 / 21
        if (s == 2 || s == 4 || s == 8 || s == 10 || s == 13) {
            s -= 1
        }
        let sc = UnicodeScalar(0x1100 + s)
           
        return sc!
    }
    
    @IBAction func addButton(_ sender: Any) {
        let rvc = self.storyboard?.instantiateViewController(identifier: "AddView")
    }
    
    @IBAction func orderOption(_ sender: Any) {
        let actionSheet = UIAlertController(title: "정렬 옵션", message: nil, preferredStyle: .actionSheet)
        
        let limitOrder = UIAlertAction(title: "유통기한", style: .default, handler: {
            (action) in
            self.orderOption = 1
            self.reload()
        })
        let nameOrder = UIAlertAction(title: "이름", style: .default, handler: {
            (action) in
            self.orderOption = 2
            self.reload()
        })
        let locationOrder = UIAlertAction(title: "위치", style: .default, handler: {
            (action) in
            self.orderOption = 3
            self.reload()
        })
        
        
        actionSheet.addAction(limitOrder)
        actionSheet.addAction(nameOrder)
        actionSheet.addAction(locationOrder)
        updateInformation()
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true,  completion: nil)
    }
    
    func delegateReload() {
        self.updateInformation()
        self.reload()
    }
}

extension FoodListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Return Section Count
        //if searchController.searchBar.text?.isEmpty == false {
            //return 0
        //}
        if (searchActive) {
            return 1
        }
        
        if orderOption == 1 {
            return sortedDateSection.count
        } else if orderOption == 2 {
            return Array(Set(self.initCharacter)).count
        } else if (orderOption == 3) {
            return sortedLocationSection.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formatter.dateFormat = "yyyy.MM.dd"
        
        let foodList = Array(temp)
        
        //Return number of rows in section
        if (searchActive) {
            return filtered.count
        }
        
        if orderOption == 1 {
            let interval = sortedDateSection[section].leftDate
            var leftinterval:Double = -1000000
            
            if section != 0 {
                leftinterval = sortedDateSection[section-1].leftDate
            }
            
            return foodList.filter{ ($0.limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < ($0.limitDate.timeIntervalSinceNow / 86400)}.count
            
        } else if orderOption == 2 {
            let charactor = Array(Set(self.initCharacter)).sorted()[section]
            
            return foodList.filter { self.splitText(text: $0.name) == charactor}.count
            
        } else if orderOption == 3 {
            return foodList.filter { $0.location == sortedLocationSection[section]}.count
        }
        
        return 1
    }
    
    //Get Custom Cell Information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodList = Array(temp).sorted{ $0.name < $1.name }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: indexPath) as! FoodListCell
        
        if (searchActive) {
            cell.foodName.text = filtered[indexPath.row].name
            cell.limitDate.text = formatter.string(from: filtered[indexPath.row].limitDate)
        
        } else if orderOption == 1 {
            let interval = sortedDateSection[indexPath.section].leftDate
            var leftinterval:Double = -1000000
            
            if indexPath.section != 0 {
                leftinterval = sortedDateSection[indexPath.section-1].leftDate
            }
            
            cell.foodName.text = foodList.filter { ($0.limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < ($0.limitDate.timeIntervalSinceNow / 86400) }.sorted{ $0.limitDate < $1.limitDate }[indexPath.row].name
            cell.limitDate.text = formatter.string(from: foodList.filter { ($0.limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < ($0.limitDate.timeIntervalSinceNow / 86400) }.sorted{ $0.limitDate < $1.limitDate}[indexPath.row].limitDate) + " 까지"
        } else if orderOption == 2 {
            //각 섹션의 첫 문자를 charactor로 선언
            let charactor = Array(Set(self.initCharacter)).sorted()[indexPath.section]
            
            cell.foodName.text = foodList.filter { self.splitText(text: $0.name) == charactor}[indexPath.row].name
            cell.limitDate.text = formatter.string(from: foodList.filter { self.splitText(text: $0.name) == charactor}[indexPath.row].limitDate) + " 까지"
                
        } else if orderOption == 3 {
            cell.foodName.text = foodList.filter { $0.location == self.sortedLocationSection[indexPath.section]}[indexPath.row].name
            cell.limitDate.text = formatter.string(from: foodList.filter { $0.location == self.sortedLocationSection[indexPath.section]}[indexPath.row].limitDate) + " 까지"
        }
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let foodList = Array(temp)
        
        if (searchActive) {
            return "검색 결과"
        } else if orderOption == 1 {
            return sortedDateSection[section].string
        } else if orderOption == 2 {
            return String(Array(Set(foodList.map { self.splitText(text: $0.name)})).sorted()[section])
        } else if orderOption == 3 {
            return sortedLocationSection[section]
        }
        return ""
    }
    
    //Swipe Delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let foodList = Array(temp).sorted{ $0.name < $1.name }
        self.updateInformation()
        
        if segue.identifier == "ListModal" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "FoodList", bundle: nil)
            let detailView = storyBoard.instantiateViewController(withIdentifier: "ListModal") as! ListModalViewController
            let senderCell = sender as! FoodListCell
            let indexPath = tableView.indexPath(for: senderCell)!
            
            if (searchActive) {
                detailView.food = filtered[indexPath.row]
            }
            else if orderOption == 1 {
                for i in 0..<dateOfSection.count-1 {
                    if dateOfSection[i].string == sortedDateSection[indexPath.section].string {
                        detailView.food = sortByDate[i][indexPath.row]
                        break
                    }
                }
            } else if orderOption == 2 {
                let charactor = Array(Set(self.initCharacter)).sorted()[indexPath.section]
                detailView.food = foodList.filter { self.splitText(text: $0.name) == charactor}[indexPath.row]
            } else if orderOption == 3 {
                for i in 0..<foodLocation.count {
                    if foodLocation[i] == sortedLocationSection[indexPath.section] {
                        detailView.food = sortedLocation[i][indexPath.row]
                        break
                    }
                }
            }
            detailView.delegate = self
            self.present(detailView, animated: true, completion: nil)
        }}
}

extension FoodListViewController {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension FoodListViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let foodList = Array(temp)
        filtered = foodList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}

extension FoodListViewController: FoodListCellDelegate {
    func subscribeButtonTapped(_ foodListCell: FoodListCell, subsribeButtonTappedFor food: Food) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FoodList", bundle: nil)
        let rvc = storyBoard.instantiateViewController(withIdentifier: "ListModal") as! ListModalViewController
        rvc.food = food
        rvc.delegate = self
        self.present(rvc, animated: true, completion: nil)
    }
}
