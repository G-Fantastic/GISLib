//
//  GISCircle.swift
//  GISLib
//
//  Created by GG on 2019/5/30.
//

import Foundation
import Logging


/// GIS地图上的圆
public struct GISCircle {
    /// 圆心经纬度坐标
    public var centerLatLon: GISLatLon
    /**
     * 圆的半径（单位：米(m)）
     *
     * 圆的半径不能大于地球赤道周长的1/4，否则生成有效随机点的概率将大大降低。
     */
    public var r: Double!{
        willSet{
            if newValue! > CIRCUM_4 {
                fatalError("圆的半径不能大于地球赤道周长的1/4（ \(CIRCUM_4) 米 ）")
            }
        }
    }
    /// 圆的标签
    public var label: String
    
    private var logger = Logger(label: "GISCircle")
    /// 日志等级
    public var logLevel: GISLogLevel!{
        didSet{
            logger.logLevel = map2LoggerLevel(logLevel)
        }
    }
    
    public init(_ centerLatLon: GISLatLon, _ r: Double, _ label: String = "GISCircle", logLevel: GISLogLevel = .info){
        self.centerLatLon = centerLatLon
        self.label = label
        
        defer {
            self.r = r
            self.logLevel = logLevel
        }
    }
    
}

// 生成一个随机点
extension GISCircle{
    /**
     * 圆内生成一个随机点
     *
     * 有概率生成的随机点不在圆内，当随机点不在圆内，将抛出异常
     */
    public func randomLatLon() throws -> GISLatLon{
        let randomRad = Double.random(in: 0...2 * π).roundOff(6)    // 随机弧度（必须 <= 2π）
        let randomLen = (sqrt(Double.random(in: 0...1)) * r).roundOff(3) // 随机长度（必须 <= 圆的半径R）
        let gisLatLon = try calculateLatLon(randomRad, randomLen)
        return gisLatLon
    }
    
    /**
     * 在圆内指定弧度与长度，计算一个经纬度坐标
     *
     * 不推荐使用，建议使用：randomLatLon() 方法，可在圆内生成真正的随机经纬度坐标点
     */
    public func calculateLatLon(_ radian: Double, _ len: Double) throws -> GISLatLon{
        if radian > 2 * π { throw GISCircleError.radianOver2πError("radianOver2πError: 指定的弧度值rad不能 > 2π(\(2 * π)") }
        if len > r { throw GISCircleError.lengthOverRError("lengthOverRError: 指定的长度len不能 > 圆的半径R(\(r!)") }
        
        let rad = radian == 2 * π ? 0 : radian      // 如果弧度是2π，直接置为0，因为2π和0其实是同一个弧度
        
        logger.info("随机的弧度：\(rad) *** 随机的角度值：\(rad * RAD2DEG)")
        logger.info("随机的长度（随机点到圆心的距离）：\(len)")
        
        let (absLat, absLon) = (abs(centerLatLon.latitude), abs(centerLatLon.longitude))
        logger.info("纬度绝对值：\(absLat) *** 经度绝对值：\(absLon)")
        if len == 0 { logger.warning("随机长度为：0，圆心即为随机点。");  return centerLatLon }
        if absLat == 90 {
            logger.warning("当前纬度的绝对值为：90，也就是圆心在极点。")
            let randomLatLon = randomForLat90(len)
            try verifyRandomLatLon(randomLatLon, len)
            return randomLatLon
        }
        if centerLatLon.latitude > 0 {
            logger.warning("当前圆心在北半球")
            let lenToNorthPole = GISTools.distance(centerLatLon, GISLatLon(lat: 90, lon: 0))
            logger.info("圆心到北极点的距离：\(lenToNorthPole)")
            if r > lenToNorthPole{
                logger.warning("圆心在北半球且北极点在圆内")
                switch(rad){
                case rad where rad == 0 || rad == π:
                    logger.warning("随机弧度 = 0 或 = π")
                    let randomLatLon = rad_0Orπ_NSPole(rad, len, lenToNorthPole)
                    try verifyRandomLatLon(randomLatLon, len)
                    return randomLatLon
                    
                case rad where rad > 0 && rad < π:
                    logger.warning("随机弧度 > 0 且 < π")
                    let randomLatLon = rad_0Toπ_NPole(rad, len, lenToNorthPole)
                default:
                    logger.warning("随机弧度 > π 且 < 2π")
                }
                if rad == 0 || rad == π {
                    
                }
            }
        }
        
        
        return GISLatLon()
    }
    
    
    
    
}

// 生成随机点的辅助方法
extension GISCircle{
    /// 圆心在极点（纬度绝对值为90度）时生成随机点
    private func randomForLat90(_ len: Double) -> GISLatLon {
        let randomDeg = Double(Int.random(in: 0...36000))  // 36000个角度
        let randomLon = randomDeg < 18000 ? randomDeg / 100.0 : (18000 - randomDeg) / 100.0
        logger.info("圆心在极点时，生成的随机角度：\(randomDeg) *** 随机经度：\(randomLon)")
        let latOffset = (len / DEG2M).roundOff(6)
        let randomLat = centerLatLon.latitude == 90 ? 90 - latOffset : latOffset - 90
        logger.info("圆心在极点时，生成的随机纬度：\(randomLat)")
        
        return GISLatLon(lat: randomLat, lon: randomLon)
    }
    
    /// 随机弧度 = 0 或 π （南北半球均适用）
    private func rad_0Orπ_NSPole(_ rad: Double, _ len: Double, _ lenToPole: Double) -> GISLatLon {
        let desToPole = sqrt(lenToPole * lenToPole + len * len)
        logger.info("随机点到最近的极点的距离：\(desToPole)")
        let latOffset = (desToPole / DEG2M).roundOff(6)
        let randomLat = centerLatLon.latitude > 0 ? 90 - latOffset : latOffset - 90
        let radOffset = asin(len / desToPole)
        let lonOffset = radOffset * RAD2DEG
        let tempLon = rad == 0 ? centerLatLon.longitude + lonOffset : centerLatLon.longitude - lonOffset
        let randomLon = parseLonOver180(tempLon)
        logger.info("经度偏移弧度：\(radOffset) *** 经度偏移角度：\(lonOffset) *** 纬度偏移角度：\(latOffset)")
        logger.info("随机纬度：\(randomLat) *** 随机经度：\(randomLon)")
        
        return GISLatLon(lat: randomLat, lon: randomLon)
    }
    
    
    /// 随机弧度rad: 0 < rad < π （适用于北半球）
    private func rad_0Toπ_NPole(_ rad: Double, _ len: Double, _ lenToPole: Double) -> GISLatLon {
        let radDiff90 = π/2 - rad
        let logStr = radDiff90 >= 0 ? "随机弧度rad: 0 < rad < π/2" : "随机弧度rad: π/2 < rad < π"
        logger.info("\(logStr)")
        
        // len等于这个距离的时候，纬度到达最高点，超过这个距离的时候，纬度又开始下降
        let toNearestPoint = lenToPole * cos(abs(radDiff90))  // 距离极点最近的点到当前经纬度点的距离
        logger.info("距离极点最近的点到当前经纬度点的距离为：\(toNearestPoint)")
        
        let leftLen = len - toNearestPoint  // 超过 toNearestPoint 延伸的长度
        let logStr1 = leftLen > 0 ? " leftLen > 0 " : leftLen == 0 ? " leftLen = 0 " : " leftLen < 0 "
        logger.info("\(logStr1)")
        
        let nearestPointTo90 = lenToPole * sin(abs(radDiff90))
        logger.info("当前弧度下的线段到北极点的距离：\(nearestPointTo90)")
        
        let desToPole = sqrt(leftLen * leftLen + nearestPointTo90 * nearestPointTo90)  // 随机点到极点的距离
        let randomLat = 90 - (desToPole / DEG2M).roundOff(6)
        
        let radOffset = asin(abs(leftLen) / desToPole)  // `超过`离极点最近的点之后，所偏移的经度
        let lonOffset = (leftLen > 0 ? π/2 - abs(radDiff90) + radOffset : π/2 - abs(radDiff90) - radOffset) * RAD2DEG
        
        let tempLon = radDiff90 >= 0 ? centerLatLon.longitude + lonOffset : centerLatLon.longitude - lonOffset
        let randomLon = parseLonOver180(tempLon)
        
        logger.info("经度偏移弧度：\(radOffset) *** 经度偏移角度：\(lonOffset) ")
        logger.info("随机纬度：\(randomLat) *** 随机经度：\(randomLon)")
        
        return GISLatLon(lat: randomLat, lon: randomLon)
    }
    
    
    /// 处理 > 180 或 < -180 的经度
    private func parseLonOver180(_ tempLon: Double) -> Double{
        var lon = 0.0
        if tempLon > 180 {
            lon = tempLon - 360.0
        }else if tempLon < -180{
            lon = tempLon + 360.0
        }else{
            lon = tempLon
        }
        return lon.roundOff(6)
    }
    
    /// 验证随机点的有效性
    private func verifyRandomLatLon(_ randomLatLon: GISLatLon, _ len: Double) throws{
        let distance = GISTools.distance(centerLatLon, randomLatLon)
        logger.warning("随机点到圆心的距离：\(distance) *** 随机长度：\(len)")
        logger.warning("正在验证随机点的有效性……")
        let diff = abs((distance - len) / len)
        logger.info("误差原始值为：\(diff)")
        let diffFormat = (diff * 100).roundOff(2)
        let diffStr = diffFormat < 0.01 ? "小于0.01%" : "\(diffFormat)%"
        logger.warning("误差为：\(diffStr)")
        
        if distance > r { throw GISCircleError.randomLatLonOutCircleError("RandomLatLonOutCircleError: 随机点不在圆内") }
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


/**
 * GISCircle生成的随机点时的异常枚举
 */
public enum GISCircleError: Error {
    case radianOver2πError(String)
    case lengthOverRError(String)
    case randomLatLonOutCircleError(String)
}

