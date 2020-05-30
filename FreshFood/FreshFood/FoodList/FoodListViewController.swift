//
//  FoodListViewController.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/21.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var foodList: [String] = ["가지", "딸기", "포도", "사과", "대파", "쪽파", "가위"]
    let dateOfSection: [String] = ["유통기한 임박", "유통기한 1주", "유통기한 2주", "유통기한 3주", "유통기한 4주 이상"]
    
    var orderOption = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}

extension FoodListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Return Section Count
        if orderOption == 2 {
            return Array(Set(self.foodList.map {$0.first! })).count
        }
        
        return dateOfSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return number of rows in section
        let charactor = Array(Set(self.foodList.map { $0.first!})).sorted()[section]
        
        //검색창이 비어있을 경우 section의 charactor과 이름의 첫글자가 일치하는 것만 리턴
        if self.searchBar.text?.isEmpty == true {
            return self.foodList.filter { $0.first! == charactor }.count
        }
        
        //검색창에 내용이 있는 경우 그 내용을 포함하는 이름들의 개수를 리턴
        return self.foodList.filter { $0.first! == charactor }.filter { $0.contains(self.searchBar.text!)}.count
    }
    
    //Get Custom Cell Information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //각 섹션의 첫 문자를 charactor로 선언
        let charactor = Array(Set(self.foodList.map { $0.first! })).sorted()[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: indexPath) as! FoodListCell

        // 검색창이 비어있을 경우 charactor와 같은 첫글자를 가진 이름들만 골라서 리턴
        if self.searchBar.text?.isEmpty == true {
            cell.foodName.text = self.foodList.filter { $0.first! == charactor}[indexPath.row]
        } else { // 검색창에 내용이 있는 경우 그 내용을 포함하는 이름들만 골라서 리턴
            cell.foodName.text = self.foodList.filter { $0.first! == charactor}.filter {$0.contains(self.searchBar.text!) }[indexPath.row]
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(Array(Set(foodList.map { $0.first! })).sorted()[section])
    }
    
    
    //Swipe Delete function
    func tableView(_ tableView: UITableView, commit editingSytle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //foodList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    /*
    //Send information to Modal View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MODAL_SEGUE", let vc = segue.destination as? listModalViewController {
            vc.data = textField.text
        }
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FoodListViewController: UISearchBarDelegate {
    // 검색창 내용 바뀔 때마다 tableView를 reload
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reload()
    }
}
