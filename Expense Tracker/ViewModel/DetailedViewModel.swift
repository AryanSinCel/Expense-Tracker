//
//  DetailedViewModel.swift
//  Expense Tracker
//
//  Created by Celestial on 24/12/24.
//

import Foundation

class DetailedViewModel{
    
    var isUpdating = false
    var updateDetail: Expense?
    var fsDate: Date = Date.now
    var index = Int()
    var cameFromSegue = false
    
    func getButtonTitle()->String{
        isUpdating ? Constant.editString : Constant.saveString
    }
    
    func delete(){
        DatabaseHelper.shareInstance.deleteData(index: index)
    }
    
    func edit(dict:[String:Any]){
        DatabaseHelper.shareInstance.editData(object: dict, i: index)
    }
    
    func save(dict:[String:Any]){
        DatabaseHelper.shareInstance.save(object: dict)
    }
    
    
}
