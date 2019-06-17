//
//  GMSResponseFileData.swift
//  GMServerSDK
//
//  Created by Sophie Liang on 2019/5/6.
//  Copyright © 2019 Sophie Liang. All rights reserved.
//

import Foundation

public class GMSResponseFileData {
    
    public var altitude: Double?
    public var cadence: Double?
    public var distanceKm: Double?
    public var geoIncline: Double?
    public var hr: Double?
    public var latitude: Double?
    public var longitude: Double?
    public var power: Double?
    public var powerPred: Double?
    public var second: Double?
    public var speed: Double?
    public var stamina: Double?
    public var staminaAerobic: Double?
    public var staminaAnaerobic: Double?
    
    init(from dict: [String: Any]) {
        self.altitude = (dict["al"] as? String)?.GMSDouble()
        self.cadence = (dict["ca"] as? String)?.GMSDouble()
        self.distanceKm = (dict["dist"] as? String)?.GMSDouble()
        self.geoIncline = (dict["inc"] as? String)?.GMSDouble()
        self.hr = (dict["hr"] as? String)?.GMSDouble()
        self.latitude = (dict["la"] as? String)?.GMSDouble()
        self.longitude = (dict["lo"] as? String)?.GMSDouble()
        self.power = (dict["pr"] as? String)?.GMSDouble()
        self.powerPred = (dict["pr_pred"] as? String)?.GMSDouble()
        self.second = (dict["sec"] as? String)?.GMSDouble()
        self.speed = (dict["sp"] as? String)?.GMSDouble()
        self.stamina = (dict["stm"] as? String)?.GMSDouble()
        self.staminaAerobic = (dict["aero"] as? String)?.GMSDouble()
        self.staminaAnaerobic = (dict["anae"] as? String)?.GMSDouble()
    }
}
