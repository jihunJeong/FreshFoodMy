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
}

class FoodListViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var formatter = DateFormatter()
    
    
    var carrot:Food = Food()
    var grape:Food = Food()
    var strawberry:Food = Food()
    var orange:Food = Food()
    var rice:Food = Food()
    
    var foodList: [Food] = []
    let dateOfSection: [String] = ["유통기한 임박", "유통기한 1주", "유통기한 2주", "유통기한 3주", "유통기한 4주 이상"]
    var initCharacter: [UnicodeScalar] = []
    
    //OrderOption Section
    var orderOption = 2
    
    //Searchbar Section
    var filteredList: [Food] = []
    var searchController: UISearchController!

    override func viewDidLoad() {
        formatter.dateFormat = "yyyy.MM.dd"
        
        carrot.name = "당근"
        carrot.limitDate = formatter.date(from: "2020.07.23")!
        grape.name = "포도"
        grape.limitDate = formatter.date(from: "2020.02.20")!
        strawberry.name = "딸기"
        strawberry.limitDate = formatter.date(from: "2020.05.20")!
        orange.name = "오렌지"
        orange.limitDate = formatter.date(from: "2020.09.01")!
        rice.name = "쌀"
        rice.limitDate = formatter.date(from: "2021.02.19")!
        
        
        foodList.append(carrot)
        foodList.append(grape)
        foodList.append(strawberry)
        foodList.append(orange)
        foodList.append(rice)
        
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

        let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 120.0))
        actionSheet.view.addSubview(view)

        actionSheet.addAction(UIAlertAction(title: "유통기한", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "이름", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "위치", style: .default, handler: nil))

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
        
        if orderOption == 2 {
            return Array(Set(self.initCharacter)).count
        } else if (orderOption == 1) {
            
        }
        
        return dateOfSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return number of rows in section
        let charactor = Array(Set(self.initCharacter)).sorted()[section]
        
        
        if self.searchController.searchBar.text?.isEmpty  == true {
            return self.foodList.filter {
                splitText(text: $0.name) == charactor}.count
        }
        
        // 검색창에 내용이 있는 경우 그 내용을 포함하는 이름들의 개수를 리턴
        return filteredList.count
    }
    
    //Get Custom Cell Information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //각 섹션의 첫 문자를 charactor로 선언
        let charactor = Array(Set(self.initCharacter)).sorted()[indexPath.section]

        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: indexPath) as! FoodListCell
        
       cell.delegate = self
        
        // 검색창이 비어있을 경우 charactor와 같은 첫글자를 가진 이름들만 골라서 리턴
        if self.searchController.searchBar.text?.isEmpty == true {
            cell.foodName.text = self.foodList.filter { splitText(text: $0.name) == charactor}[indexPath.row].name
            cell.limitDate.text = formatter.string(from: self.foodList.filter { splitText(text: $0.name) == charactor}[indexPath.row].limitDate)
            cell.delegate = self
            
        } else { // 검색창에 내용이 있는 경우 그 내용을 포함하는 이름들만 골라서 리턴
            cell.foodName.text = filteredList[indexPath.row].name
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(Array(Set(foodList.map { splitText(text: $0.name)})).sorted()[section])
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
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListModal" {
            let detailView = segue.destination as! ListModalViewController
            let senderCell = sender as! FoodListCell
            let indexPath = tableView.indexPath(for: senderCell)!
            let charactor = Array(Set(self.initCharacter)).sorted()[indexPath.section]
            
            detailView.food = foodList.filter { splitText(text: $0.name) == charactor}[indexPath.row]
        }
    }
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
        //self.navigationController?.pushViewController(rvc, animated: true)
        self.present(rvc, animated: true, completion: nil)
    }
}
