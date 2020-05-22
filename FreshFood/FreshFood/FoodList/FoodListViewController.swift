//
//  FoodListViewController.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/21.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController {

    @IBOutlet var FoodListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FoodListTableView.delegate = self
        //FoodListTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.FoodListTableView.dequeueReusableCell(withIdentifier: "FoodListCell", for: <#T##IndexPath#>)
        
        return cell
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
