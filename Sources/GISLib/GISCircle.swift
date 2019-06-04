//
//  GISCircle.swift
//  GISLib
//
//  Created by GG on 2019/5/30.
//

/// GIS地图上的圆
public struct GISCircle {
    /// 圆心经纬度坐标
    public var centerLatLon: GISLatLon
    /// 圆的半径（单位：米(m)）
    public var r: Double!{
        willSet{
            if newValue! > CIRCUM_4 {
                fatalError("圆的半径不能大于地球赤道周长的1/4（ \(CIRCUM_4) 米 ）")
            }
        }
    }
    /// 圆的标签
    public var label: String
    
    public init(_ centerLatLon: GISLatLon, _ r: Double, _ label: String = "GISCircle"){
        self.centerLatLon = centerLatLon
        self.label = label
        
        defer {
            self.r = r
        }
    }

}


extension GISCircle : CustomStringConvertible, CustomDebugStringConvertible{
    public var description: String {
        return "\(label)的圆心为：(lat: \(centerLatLon.latitude!), lon: \(centerLatLon.longitude!))，半径为：\(r!) 米"
    }
    
    public var debugDescription: String {
        return "debug：\(label)的圆心为：(lat: \(centerLatLon.latitude!), lon: \(centerLatLon.longitude!))，半径为：\(r!) 米"
    }
}


