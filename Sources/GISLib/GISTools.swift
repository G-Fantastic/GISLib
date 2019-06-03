//
//  GISTools.swift
//  GISLib
//
//  Created by GG on 2019/5/30.
//
import Foundation

public class GISTools {
    /// 打印当前GISLib中使用的一些参数值
    public static func printGISParams() {
        print("\n============GISLib中使用的一些参数============")
        print("          圆周率π  ➙  \(π)")
        print("　　   地球平均半径  ➙  \(EARTH_R)(m)")
        print("　　   地球赤道周长  ➙  \(CIRCUM)(m)")
        print("　地球赤道周长的1/4  ➙  \(CIRCUM_4)(m)")
        print("　地球赤道周长的1/8  ➙  \(CIRCUM_8)(m)")
        print("   角度转弧度的系数  ➙  \(DEG2RAD)")
        print("   弧度转角度的系数  ➙  \(RAD2DEG)")
        print(" 1°纬度所对应的距离  ➙  \(DEG2M)(m)")
        print("===========================================\n")
    }
}

/// 添加计算经纬度距离的方法
extension GISTools{
    /// 通过起始点与终点经纬度计算距离
    public static func distance(_ latLon1: GISLatLon, _ latLon2: GISLatLon) -> Double{
        let radLat1 = DEG2RAD * latLon1.latitude
        let radLat2 = DEG2RAD * latLon2.latitude
        let diffLat = radLat1 - radLat2
        let diffLon = (latLon1.longitude  - latLon2.longitude) * DEG2RAD
        let tempDis = 2 * asin(sqrt(pow(sin(diffLat / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(diffLon / 2), 2)))
        let distance = tempDis * EARTH_R
        return distance.roundOff(3)
    }
    
    /// 通过起始点与终点经纬度以及海拔差值计算距离
    public static func distanceWithAltitude(_ latLon1: GISLatLon, _ latLon2: GISLatLon, _ altitude1: Double, _ altitude2: Double) -> Double{
        let radLat1 = DEG2RAD * latLon1.latitude
        let radLat2 = DEG2RAD * latLon2.latitude
        let diffLat = radLat1 - radLat2
        let diffLon = (latLon1.longitude  - latLon2.longitude) * DEG2RAD
        let a = pow(sin(diffLat / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(diffLon / 2), 2)
        let b = 2 * atan2(sqrt(a), sqrt(1 - a))
        var distance = EARTH_R * b
        let diffAltitude = altitude1 - altitude2
        distance = sqrt(distance * distance + diffAltitude * diffAltitude)
        
        return distance.roundOff(3)
    }
    
}


