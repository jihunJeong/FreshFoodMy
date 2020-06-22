//
//  FoodListViewController.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/21.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

protocol FoodListCellDelegate {
    func didSelectButton(food: Food?)
    func deleteFood(food: Food?)
}

class FoodListViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct DateStruct {
        var string: String = ""
        var leftDate: Double = Double()
    }
    
    var formatter = DateFormatter()
    
    var carrot:Food = Food()
    var grape:Food = Food()
    var strawberry:Food = Food()
    var orange:Food = Food()
    var rice:Food = Food()
    
    var foodList: [Food] = []
    
    var date0: DateStruct = DateStruct(string: "유통기한 지남", leftDate: 0)
    var date1: DateStruct = DateStruct(string: "유통기한 임박", leftDate: 3)
    var date2: DateStruct = DateStruct(string: "유통기한 1주", leftDate: 7)
    var date3: DateStruct = DateStruct(string: "유통기한 2주", leftDate: 14)
    var date4: DateStruct = DateStruct(string: "유통기한 3주", leftDate: 21)
    var date5: DateStruct = DateStruct(string: "유통기한 4주 이상", leftDate: 1000000000000000)
    
    var dateOfSection: [DateStruct] = []
    var initCharacter: [UnicodeScalar] = []
    var foodLocation: [String] = []
    var sortedDateSection: [DateStruct] = []
    var sortedLocation: [String] = []

    //OrderOption Section
    var orderOption = 1
    
    //Searchbar Section
    var filteredList: [Food] = []
    var sortByDate: [[Food]] = [[],[],[],[],[],[]]
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        formatter.dateFormat = "yyyy.MM.dd"
    
        carrot.name = "당근"
        carrot.limitDate = formatter.date(from: "2020.06.23")!
        carrot.location = "냉장고"
        
        grape.name = "포도"
        grape.limitDate = formatter.date(from: "2020.06.30")!
        grape.location = "냉장고"
        
        strawberry.name = "딸기"
        strawberry.limitDate = formatter.date(from: "2020.07.20")!
        strawberry.location = "냉장고"
        
        orange.name = "오렌지"
        orange.limitDate = formatter.date(from: "2020.07.28")!
        orange.location = "냉장고"
        
        rice.name = "쌀"
        rice.limitDate = formatter.date(from: "2021.02.19")!
        rice.location = "냉동고"
        
        foodList = [carrot, grape, strawberry, orange, rice]
        dateOfSection = [date0, date1, date2, date3, date4, date5]
        foodLocation = ["냉장고", "냉동고"]
        foodList.sort( by: {$0.name < $1.name} )
        
        for i in 0...foodList.count-1 {
            for j in 0...dateOfSection.count-1 {
                let interval:Double = dateOfSection[j].leftDate
                var leftinterval:Double = -10000
                if j != 0 {
                    leftinterval = dateOfSection[j-1].leftDate
                }
                if (foodList[i].limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < (foodList[i].limitDate.timeIntervalSinceNow / 86400) {
                    sortByDate[j].append(foodList[i])
                    if sortedDateSection.contains(where: { $0.string == dateOfSection[j].string }) {
                        continue
                    }
                    sortedDateSection.append(dateOfSection[j])
                }
            }
            if sortedDateSection.count == 6 {
                break
            }
        }
        sortedDateSection.sort( by: {$0.leftDate < $1.leftDate})
        super.viewDidLoad()
        
        tableView.dataSource = self
        filteredList = foodList
        
        for food in foodList {
            initCharacter.append(splitText(text: food.name))
        }
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
        self.reload()
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    //첫 자음을 얻는 함수
    func splitText(text: String) -> UnicodeScalar{
           let text = text.first

           let val = (UnicodeScalar(String(text!))?.value)!
           
           let s = (val - 0xac00) / 28 / 21
           let sc = UnicodeScalar(0x1100 + s)
           
           return sc!
    }
    
    @IBAction func addButton(_ sender: Any) {
        let rvc = self.storyboard?.instantiateViewController(identifier: "AddView")
        self.present(rvc!, animated: true, completion: nil)
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

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true,  completion: nil)
    }
}

extension FoodListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Return Section Count
        if searchController.searchBar.text?.isEmpty == false {
            return 0
        }
        
        if orderOption == 1 {
            return sortedDateSection.count
        } else if orderOption == 2 {
            return Array(Set(self.initCharacter)).count
        } else if (orderOption == 3) {
            return foodLocation.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formatter.dateFormat = "yyyy.MM.dd"
        
        //Return number of rows in section
        if orderOption == 1 {
            let interval = sortedDateSection[section].leftDate
            var leftinterval:Double = -1000000
            
            if section != 0 {
                leftinterval = sortedDateSection[section-1].leftDate
            }
            
            return self.foodList.filter{ ($0.limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < ($0.limitDate.timeIntervalSinceNow / 86400)}.count
            
        } else if orderOption == 2 {
            let charactor = Array(Set(self.initCharacter)).sorted()[section]
            
            
            if self.searchController.searchBar.text?.isEmpty  == true {
                return self.foodList.filter {
                    splitText(text: $0.name) == charactor}.count
            }
            
            // 검색창에 내용이 있는 경우 그 내용을 포함하는 이름들의 개수를 리턴
            return filteredList.count
        } else if orderOption == 3 {
            if self.searchController.searchBar.text?.isEmpty == true {
                return self.foodList.filter { $0.location == foodLocation[section]}.count
            }
        }
        
        return 1
    }
    
    //Get Custom Cell Information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: indexPath) as! FoodListCell
        cell.delegate = self
        
        if orderOption == 1 {
            let interval = sortedDateSection[indexPath.section].leftDate
            var leftinterval:Double = -1000000
            
            if indexPath.section != 0 {
                leftinterval = sortedDateSection[indexPath.section-1].leftDate
            }
            
            if self.searchController.searchBar.text?.isEmpty == true {
                cell.foodName.text = self.foodList.filter { ($0.limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < ($0.limitDate.timeIntervalSinceNow / 86400) }[indexPath.row].name
                cell.limitDate.text = formatter.string(from: self.foodList.filter { ($0.limitDate.timeIntervalSinceNow / 86400) < interval && leftinterval < ($0.limitDate.timeIntervalSinceNow / 86400) }[indexPath.row].limitDate) + " 까지"
            }
        } else if orderOption == 2 {
            //각 섹션의 첫 문자를 charactor로 선언
            let charactor = Array(Set(self.initCharacter)).sorted()[indexPath.section]

            // 검색창이 비어있을 경우 charactor와 같은 첫글자를 가진 이름들만 골라서 리턴
            if self.searchController.searchBar.text?.isEmpty == true {
                cell.foodName.text = self.foodList.filter { splitText(text: $0.name) == charactor}[indexPath.row].name
                cell.limitDate.text = formatter.string(from: self.foodList.filter { splitText(text: $0.name) == charactor}[indexPath.row].limitDate) + " 까지"
                
            } else { // 검색창에 내용이 있는 경우 그 내용을 포함하는 이름들만 골라서 리턴
                cell.foodName.text = filteredList[indexPath.row].name
            }
        } else if orderOption == 3 {
            if self.searchController.searchBar.text?.isEmpty == true {
                cell.foodName.text = self.foodList.filter { $0.location == foodLocation[indexPath.section]}[indexPath.row].name
                cell.limitDate.text = formatter.string(from: self.foodList.filter { $0.location == foodLocation[indexPath.section]}[indexPath.row].limitDate) + " 까지"
            }
        }
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if orderOption == 1 {
            /*
            let interval = dateOfSection[section].leftDate
            
            if self.foodList.filter { ($0.limitDate.timeIntervalSinceNow / 86400) < interval}.count == 0 {
                return ""
            }*/
            return sortedDateSection[section].string
        } else if orderOption == 2 {
            return String(Array(Set(foodList.map { splitText(text: $0.name)})).sorted()[section])
        } else if orderOption == 3 {
            return foodLocation[section]
        }
        return ""
    }
    
    //Swipe Delete function
    func tableView(_ tableView: UITableView, commit editingSytle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //foodList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredList = searchText.isEmpty ? foodList : foodList.filter { $0.name.contains(self.searchController.searchBar.text!)
                return true
            }
        }
        
        self.reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListModal" {
            let detailView = segue.destination as! ListModalViewController
            let senderCell = sender as! FoodListCell
            let indexPath = tableView.indexPath(for: senderCell)!
            if orderOption == 1 {
                for i in 0...dateOfSection.count-1 {
                    if dateOfSection[i].string == sortedDateSection[indexPath.section].string {
                        detailView.food = sortByDate[i][indexPath.row]
                        break
                    }
                }
            } else if orderOption == 2 {
                let charactor = Array(Set(self.initCharacter)).sorted()[indexPath.section]
                detailView.food = foodList.filter { splitText(text: $0.name) == charactor}[indexPath.row]
            } else if orderOption == 3 {
                var cnt = 0
                let locate = foodLocation[indexPath.section]
                for i in 0...foodList.count-1 {
                    if foodList[i].location == locate {
                        cnt += 1
                        if cnt == indexPath.row+1 {
                            detailView.food = foodList.filter { $0.name == foodList[i].name && $0.limitDate == foodList[i].limitDate}[0]
                            break
                        }
                    }
                }
    }}}
}

extension FoodListViewController: UISearchBarDelegate {
    // 검색창의 내용이 바뀔 때마다 tableView를 reload해줘서 반영
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reload()
    }
}

extension FoodListViewController: FoodListCellDelegate {
    func didSelectButton(food: Food?) {
        let storyboard = self.storyboard
        let rvc = storyboard?.instantiateViewController(withIdentifier: "ListModal") as! ListModalViewController
        rvc.food = food
        self.navigationController?.pushViewController(rvc, animated: true)
        //self.present(rvc, animated: true, completion: nil)
    }
    
    func deleteFood(food: Food?) {
        print(food!.name)
        let index = self.foodList.firstIndex(where: {$0.name == food?.name && $0.limitDate == food?.limitDate})
        self.foodList.remove(at: index!)
        self.reload()
    }
}
