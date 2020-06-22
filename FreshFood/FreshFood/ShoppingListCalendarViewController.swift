//
//  ShoppingListCalendarViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import FSCalendar

class ShoppingListCalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
    
    @IBOutlet var calendar: FSCalendar!
    
    weak var delegate:ShoppingListCalendarDelegator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        // Do any additional setup after loading the view.
    }
//    
//    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//    }
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        print(dateFormatter.string(from: date))
        self.delegate?.dateSelected(selectDate: date)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
protocol ShoppingListCalendarDelegator:AnyObject {
    func dateSelected(selectDate:Date)
}
