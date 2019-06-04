//
//  GISLatLon.swift
//  GISLib
//
//  Created by GG on 2019/5/29.
//

/// 经纬度坐标点
public struct GISLatLon {
    /// 纬度
    public var latitude: Double!{
        willSet{
            if newValue! < -90 || newValue! > 90 {
                fatalError("纬度范围必须为[-90, 90]")
            }
        }
    }
    /// 经度
    public var longitude: Double!{
        willSet{
            if newValue! < -180 || newValue! > 180 {
                fatalError("经度范围必须为[-180, 180]")
            }
        }
    }
    
    public init(lat latitude: Double = 0.0, lon longitude: Double = 0.0){
        defer {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
}


extension GISLatLon : CustomStringConvertible, CustomDebugStringConvertible{
    public var description: String {
        return "经纬度坐标 ➙ (lat: \(latitude!), lon: \(longitude!))"
    }
    
    public var debugDescription: String {
        return "debug：经纬度坐标 ➙ (lat: \(latitude!), lon: \(longitude!))"
    }
    
    
}

