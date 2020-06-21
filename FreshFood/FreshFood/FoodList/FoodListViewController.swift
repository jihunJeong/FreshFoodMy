//
//  FoodListViewController.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/21.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

protocol FoodListCellDelegate {
    func didSelectButton(food: String?)
}

class FoodListViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var foodList: [String] = ["가지", "딸기", "포도", "사과", "대파", "쪽파", "가위", "고추", "귤", "쌀", "계란", "만두", "새우"].sorted()
    let dateOfSection: [String] = ["유통기한 임박", "유통기한 1주", "유통기한 2주", "유통기한 3주", "유통기한 4주 이상"]
    var initCharacter: [UnicodeScalar] = []
    
    //OrderOption Section
    var orderOption = 2
    
    //Searchbar Section
    var filteredList: [String]!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        filteredList = foodList
        
        for food in foodList {
            initCharacter.append(splitText(text: food))
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
                splitText(text: $0) == charactor}.count
        }
        
        // 검색창에 내용이 있는 경우 그 내용을 포함하는 이름들의 개수를 리턴
        return filteredList.count
    }
    
    //Get Custom Cell Information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //각 섹션의 첫 문자를 charactor로 선언
        let charactor = Array(Set(self.initCharacter)).sorted()[indexPath.section]

        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: indexPath) as! FoodListCell
        
        cell.foodName.text = foodList[indexPath.row]
        cell.delegate = self
        
        // 검색창이 비어있을 경우 charactor와 같은 첫글자를 가진 이름들만 골라서 리턴
        if self.searchController.searchBar.text?.isEmpty == true {
            cell.foodName.text = self.foodList.filter { splitText(text: $0) == charactor}[indexPath.row]
            
        } else { // 검색창에 내용이 있는 경우 그 내용을 포함하는 이름들만 골라서 리턴
            cell.textLabel?.text = filteredList[indexPath.row]
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(Array(Set(foodList.map { splitText(text: $0)})).sorted()[section])
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
            filteredList = searchText.isEmpty ? foodList : foodList.filter { $0.contains(self.searchController.searchBar.text!)
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
            let senderCellName = foodList[indexPath.row]
            print(senderCellName)
            detailView.detailName?.text = senderCellName
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
    func didSelectButton(food: String?) {
        let storyboard = self.storyboard
        let rvc = storyboard?.instantiateViewController(withIdentifier: "ListModal") as! ListModalViewController
        print(food)
        rvc.detailName?.text = food
        self.navigationController?.pushViewController(rvc, animated: true)
    }
}
