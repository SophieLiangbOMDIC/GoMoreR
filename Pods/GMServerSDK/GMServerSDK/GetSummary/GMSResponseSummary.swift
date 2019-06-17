//
//  GMSResponseSummary.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/3.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseSummary {
    
    public var typeId: GMSTypeId?
    public var fileStaminaLevel: String?
    public var paceArray: [GMSResponseBestRunningTime] = []
    public var staminaLevelArray: [Double?] = []
    public var vo2Max: [Double?] = []
    public var lthr2: [Double?] = []
    public var ltsp2: [Double?] = []
    public var ftpPower: [Double?] = []
    
    init(from dict: [String: Any]) {
        self.typeId = GMSTypeId(rawValue: dict["type_id"] as? String ?? "")
        self.fileStaminaLevel = dict["summary_file_stamina_level"] as? String
        
        self.paceArray = []
        for pace in ((dict["summary_file_pace"] as? [[String: Any]]) ?? []) {
            self.paceArray.append(GMSResponseBestRunningTime(from: pace))
        }
        
        self.staminaLevelArray = []
        for level in ((dict["summary_file_stamina_level"] as? [[String: Any]]) ?? []) {
            let level = level["level"] as? String
            self.staminaLevelArray.append(level?.GMSDouble())
        }
        
        self.vo2Max = []
        for vo2 in ((dict["summary_vo2max"] as? [String]) ?? []) {
            self.vo2Max.append(vo2.GMSDouble())
        }
        
        self.lthr2 = []
        for lthr2 in ((dict["summary_lthr2"] as? [String]) ?? []) {
            self.lthr2.append(lthr2.GMSDouble())
        }
        
        self.ltsp2 = []
        for ltsp2 in ((dict["summary_ltsp2"] as? [String]) ?? []) {
            self.ltsp2.append(ltsp2.GMSDouble())
        }
        
        self.ftpPower = []
        for ftpPower in ((dict["summary_ftp_power"] as? [String]) ?? []) {
            self.ftpPower.append(ftpPower.GMSDouble())
        }
        
    }
}
