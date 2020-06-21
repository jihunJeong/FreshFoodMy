//
//  listModalViewController.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/30.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class ListModalViewController: UIViewController {
    
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailType: UILabel!
    @IBOutlet weak var detailLimitDate: UILabel!
    @IBOutlet weak var detailBuyDate: UILabel!
    @IBOutlet weak var detailMemo: UILabel!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: { () -> Void in})
    }
    override func viewWillAppear(_ animated: Bool) {
        self.detailName.text = "딸기"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteAlert(_ sender: Any) {
        Output_Alert(title: "정말 삭제 하시겠습니까?", message: "되돌릴 수 업습니다", text: "취소")
    }
    
    func Output_Alert(title : String, message : String, text : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        let deleteButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive, handler: nil)
        
        alertController.addAction(okButton)
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
