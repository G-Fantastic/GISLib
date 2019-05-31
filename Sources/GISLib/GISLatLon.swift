//
//  GISLatLon.swift
//  GISLib
//
//  Created by GG on 2019/5/29.
//

/// 经纬度坐标点
public struct GISLatLon {
    public var latitude = 0.0   // 纬度
    public var longitude = 0.0  // 经度
    
    public init(){ }
    
    public init(lat latitude: Double, lon longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
}


extension GISLatLon : CustomStringConvertible, CustomDebugStringConvertible{
    public var description: String {
        return "经纬度坐标 ➙ (lat: \(latitude), lon: \(longitude))"
    }
    
    public var debugDescription: String {
        return "debug：经纬度坐标 ➙ (lat: \(latitude), lon: \(longitude))"
    }
    
    
}

