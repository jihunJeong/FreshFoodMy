//
//  ShoppingListAddTempTableViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/24.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ShoppingListTempCell: UITableViewCell{
    
    var foodNameText: UILabel!
    var limitDateText: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.foodNameText = UILabel()
        self.foodNameText.numberOfLines = 1
        self.foodNameText.translatesAutoresizingMaskIntoConstraints = false
        self.foodNameText.textAlignment = .left
        self.foodNameText.textColor = UIColor.black
        self.contentView.addSubview(self.foodNameText)
        
        let margins = self.layoutMarginsGuide
          self.foodNameText.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
          self.foodNameText.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
          self.foodNameText.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
          self.foodNameText.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        
        self.limitDateText = UILabel()
        self.limitDateText.numberOfLines = 1
        self.limitDateText.translatesAutoresizingMaskIntoConstraints = false
        self.limitDateText.textAlignment = .center
        self.limitDateText.textColor = UIColor.black
        self.contentView.addSubview(self.limitDateText)
        
        let limitDateMargins = self.layoutMarginsGuide
          self.limitDateText.leftAnchor.constraint(equalTo: limitDateMargins.leftAnchor).isActive = true
          self.limitDateText.topAnchor.constraint(equalTo: limitDateMargins.topAnchor).isActive = true
          self.limitDateText.rightAnchor.constraint(equalTo: limitDateMargins.rightAnchor).isActive = true
          self.limitDateText.bottomAnchor.constraint(equalTo: limitDateMargins.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class ShoppingListAddTempTableViewController: UITableViewController {
     
       @IBOutlet var AddListView: UITableView!
    
    
       var db = Firestore.firestore().collection("FreshFood")
       var dataCount :Int = 0
       var basicFoodList = [BasicFood]()
        var selectedRow:Int = -1
       var searchActive : Bool = false
       var filtered:[BasicFood] = []
    weak var delegate:ShoppingListAddTempTableViewControllerDelegator?

       
       var formatter = DateFormatter()
       
       @IBOutlet weak var searchBar: UISearchBar!
       var searchController:UISearchController!
       
       override func viewDidLoad() {
        
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.downloadFreshFood()
        }
           
        AddListView.reloadData()
        tableView.tableFooterView = UIView()

        searchBar.delegate = self

    }
       
       required init?(coder aCoder: NSCoder) {
             super.init(coder: aCoder)

       }
       
       func downloadFreshFood(){
           
           db.getDocuments { (snapshot, error) in
               guard let snapshot = snapshot else {
                   return
                 }
                 for doc in snapshot.documents {
                   print("\(doc.documentID) =>  \(doc.data())")
                   let name = doc.documentID
                   let limitdate = doc.get("유통기한") as! String
                   print(limitdate)
                   let type = doc.get("범주") as! String
                   print(type)
                   self.basicFoodList.append(BasicFood(type: type, limitdate: limitdate, name: name))
                   self.dataCount += 1
                 }
               self.AddListView.reloadData()
               }
           
           }


       // MARK: - Table view data source

       override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           if(searchActive) {
               return filtered.count
           } else {
               return dataCount
           }
       }

       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

           
           
           let cell = ShoppingListTempCell()
           
           if(searchActive) {

               cell.foodNameText.text = filtered[indexPath.row].name
               cell.limitDateText.text = filtered[indexPath.row].limitdate
    
           }else{
           
               
           let foodName = basicFoodList[indexPath.row].name
               cell.foodNameText.text = foodName
           
           let limitDate = basicFoodList[indexPath.row].limitdate
               cell.limitDateText.text = limitDate
               //cell.typesOfFridgeLabel.text = fridgeType
           // Configure the cell...
           }
           return cell
           
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       selectedRow = indexPath.row
        let row = tableView.indexPathForSelectedRow?.row ?? 0
        let dataObject = basicFoodList[row]
        self.delegate?.getData(ingredientName: dataObject.name, ingredientType:  dataObject.type)
        self.presentingViewController?.dismiss(animated: true, completion: nil)

            
       }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//    }

       
       
//       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           if segue.identifier == "ShoppingListTempSegue"{
////               let row = tableView.indexPathForSelectedRow?.row ?? 0
////                    let dataObject = basicFoodList[row]
////                    if let nextViewcontroller = segue.destination as? ShoppingListAddViewController{
////                       // nextViewcontroller.ingredientName = dataObject.name
////                       // nextViewcontroller.limitDate = dataObject.limitdate
////                        nextViewcontroller.getData(ingredientName: dataObject.name, ingredientType:  dataObject.type)
//////                        navigationController?.popViewController(animated: true)
////               }
//           }
//       }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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

extension ShoppingListAddTempTableViewController: UISearchBarDelegate{

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
            filtered = basicFoodList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                if(filtered.count == 0){
                    searchActive = false;
                } else {
                    searchActive = true;
                }
                self.tableView.reloadData()
            }
    }

protocol ShoppingListAddTempTableViewControllerDelegator: AnyObject {
    func getData(ingredientName: String, ingredientType:  String)
}
