//
//  IngredientViewController.swift
//  ManageIngredient
//
//  Created by 정지훈 on 2020/05/14.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return data.count
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

            let detail: Detail = DetailList[indexPath.row]
            cell.textLabel!.text = detail.name
            cell.detailTextLabel!.text = String(detail.quantity)


            return cell
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
