//
//  listModalViewController.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/30.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift

protocol ModalActionDelegate {
    func delegateReload()
}

class ListModalViewController: UIViewController {
    
    @IBOutlet weak var detailName: UILabel!

    struct ListData {
        var type: String = ""
        var data: String = ""
    }
    var formatter = DateFormatter()
    var food: Food?
    let realm = try! Realm()
    var data: [ListData] = []
    
    var delegate : ModalActionDelegate?
    func didSelectButton(food: Food?) {
        self.food = food
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: { () -> Void in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.detailName.text = food
    }
    override func viewDidLoad() {
        formatter.dateFormat = "yyyy.MM.dd"
        
        super.viewDidLoad()
        
        detailName.text = food!.name
        data.append(ListData(type: "유통기한", data: formatter.string(from: food!.limitDate)))
        data.append(ListData(type: "수량", data: String(food!.quantity)))
        data.append(ListData(type: "위치", data: food!.location))
        data.append(ListData(type: "범주", data: food!.type))
        data.append(ListData(type: "메모", data: food!.memo))
    }
    
    @IBAction func deleteAlert(_ sender: Any) {
        Output_Alert(title: "정말 삭제 하시겠습니까?", message: "되돌릴 수 없습니다", text: "취소")
    }
    
    func Output_Alert(title : String, message : String, text : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        let deleteButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive) {
            (action) in
            do {
                try self.realm.write {
                    //let predicate = NSPredicate(format: "counterid = \(c.id)")
                    //let children = self.realm.objects(Food.self).filter(predicate)
                    //self.realm.delete(children)
                    let predicate = NSPredicate(format: "name = %@", self.food?.name as! CVarArg)
                    self.realm.delete(self.realm.objects(Food.self).filter(predicate)) //this should be deleted after
                }
            } catch {
                print("Error Delete \(error)")
            }
            
            self.delegate?.delegateReload()
            self.dismiss(animated:true, completion: nil)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(deleteButton)
        return self.present(alertController, animated: true, completion: nil)
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

extension ListModalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ModalTableViewCell", for: indexPath)
        
        cell.textLabel!.text = data[indexPath.row].type
        cell.detailTextLabel!.text = data[indexPath.row].data
        
        return cell
    }
}
