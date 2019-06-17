//
//  GMSRequestDataWorkoutList.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSRequestWorkoutList {
    
    public var typeId: GMSTypeId
    public var page: Int
    public var pageNum: Int
    public var dateStart: String?
    public var dateEnd: String?
    public var flagCalc: String?
    
    public init(typeId: GMSTypeId, page: Int, pageNum: Int, dateStart: String?, dateEnd: String?, flagCalc: String?) {
        self.typeId = typeId
        self.page = page
        self.pageNum = pageNum
        self.dateEnd = dateEnd
        self.dateStart = dateStart
        self.flagCalc = flagCalc
    }
    
    func toDict() -> [String: Any] {
        
        var dict: [String: Any] = [:]
        dict["type_id"] = self.typeId.rawValue
        dict["page"] = String(self.page)
        dict["page_num"] = String(self.pageNum)
        if let dateStart = self.dateStart {
            dict["period_start"] = dateStart
        }
        
        if let dateEnd = self.dateEnd {
            dict["period_end"] = dateEnd
        }
        
        if let flagCalc = self.flagCalc {
            dict["flag_calc"] = flagCalc
        }
        
        return dict
        
    }
}
