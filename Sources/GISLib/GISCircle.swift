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
     *
     */
    public func randomLatLon() throws -> GISLatLon{
        let randomRad = Double.random(in: 0...π2)    // 随机弧度（必须 <= 2π）
        let randomLen = (sqrt(Double.random(in: 0...1)) * r).roundOff(3) // 随机长度（必须 <= 圆的半径R）
        let gisLatLon = try calculateLatLon(randomRad, randomLen)
        return gisLatLon
    }
    
    /**
     * 在圆内指定弧度与长度，计算一个经纬度坐标
     *
     * 不推荐使用，建议使用：randomLatLon() 方法，可在圆内生成真正的随机经纬度坐标点
     *
     *  - parameters:
     *    - radian: 弧度。⚠️由于Double精度问题，所以此函数内部对radian只取小数点后15位有效位
     *    - len: 长度。
     */
    public func calculateLatLon(_ radian: Double, _ len: Double) throws -> GISLatLon{
        let roundRadian = radian.roundOff(15)
        logger.info("弧度取15位有效位的结果为：\(roundRadian)")
        if roundRadian > π2 { throw GISCircleError.radianOver2πError("radianOver2πError: 指定的弧度值rad不能 > 2π(\(π2))") }
        if len > r { throw GISCircleError.lengthOverRError("lengthOverRError: 指定的长度len不能 > 圆的半径R(\(r!)米)") }
        
        let rad = roundRadian == π2 ? 0 : roundRadian      // 如果弧度是2π，直接置为0，因为2π和0其实是同一个弧度
        
        logger.info("\(self)")
        logger.info("随机的弧度：\(rad) *** 随机的角度值：\(rad * RAD2DEG)")
        logger.info("随机的长度（随机点到圆心的距离）：\(len)")
        
        let (absLat, absLon) = (abs(centerLatLon.latitude), abs(centerLatLon.longitude))
        logger.info("纬度绝对值：\(absLat) *** 经度绝对值：\(absLon)")
        
        
        var randomLatLon = GISLatLon()
        let switchTuple = (len, absLat, centerLatLon.latitude!)
        
        
        switch switchTuple {
        case (0, _, _):
            logger.warning("随机长度为：0，圆心即为随机点。")
            randomLatLon = GISLatLon(lat: centerLatLon.latitude.roundOff(6), lon: centerLatLon.longitude.roundOff(6))
            
        case (_, 90, _):
            logger.warning("当前纬度的绝对值为：90，也就是圆心在极点。")
            randomLatLon = randomForLat90(len)
            
        case (_, _, let centerLat) where centerLat != 0:
            centerLat > 0 ? logger.warning("当前圆心在北半球") : logger.warning("当前圆心在南半球")
            let lenToPole = centerLat > 0 ? GISTools.distance(centerLatLon, GISLatLon(lat: 90, lon: 0))
                                          : GISTools.distance(centerLatLon, GISLatLon(lat: -90, lon: 0))
            
            logger.info("圆心到最近的极点的距离：\(lenToPole)")
            if r > lenToPole{
                centerLat > 0 ? logger.warning("圆心在北半球且北极点在圆内") : logger.warning("圆心在南半球且南极点在圆内")
                switch(rad){
                case rad where rad == 0 || rad == π:
                    logger.warning("随机弧度 = 0 或 = π")
                    randomLatLon = rad_0Orπ(rad, len, lenToPole)
                    
                case rad where rad > 0 && rad < π:
                    logger.warning("随机弧度 > 0 且 < π")
                    randomLatLon = rad_0Toπ(rad, len, lenToPole)
                    
                default:
                    logger.warning("随机弧度 > π 且 < 2π")
                    randomLatLon = rad_πTo2π(rad, len, lenToPole)
                }
            }
            
        default:
            logger.warning("普通算法取随机点")
            randomLatLon = commonCase(rad, len)
        }
        
        if len != 0 {
            try verifyRandomLatLon(randomLatLon, len)   // 校验生成的经纬度是否有效（是否在圆内）
        }
        
        // 第一次取精度可能会出现后面有 00000001 或 99999999 的情况，所以需要再做一次取精度的步骤
        randomLatLon = GISLatLon(lat: randomLatLon.latitude.roundOff(6), lon: randomLatLon.longitude.roundOff(6))
        return randomLatLon
    }
    
}

// 生成随机点的辅助方法
extension GISCircle{
    /// 圆心在极点（纬度绝对值为90度）时生成随机点
    private func randomForLat90(_ len: Double) -> GISLatLon {
        let randomDeg = Double(Int.random(in: 0...36000))  // 36000个角度
        let randomLon = randomDeg < 18000 ? randomDeg / 100.0 : (18000 - randomDeg) / 100.0
        logger.info("圆心在极点时，生成的随机角度：\(randomDeg / 100) *** 随机经度：\(randomLon)")
        let latOffset = (len / DEG2M).roundOff(6)
        let randomLat = centerLatLon.latitude == 90 ? 90 - latOffset : latOffset - 90
        logger.info("圆心在极点时，生成的随机纬度：\(randomLat)")
        
        return GISLatLon(lat: randomLat, lon: randomLon)
    }
    
    /**
     * 随机弧度rad: rad = 0 或 rad = π
     */
    private func rad_0Orπ(_ rad: Double, _ len: Double, _ lenToPole: Double) -> GISLatLon {
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
    
    
    /**
     * 随机弧度rad: 0 < rad < π
     *
     * ⚠️⚠️⚠️（以下说明只针对本函数而言）：
     *
     * 由于只是要在圆内取一个随机点，所以对于随机弧度的取值是多少并不关心，因为本来就是随机的。因此，做如下约定：
     *
     * ➢ 圆心点在北半球或赤道时，圆心点与北极点的连线的弧度当作是 π/2 (90°)
     *
     * ➢ 圆心点在南半球时，圆心点与南极点的连线的弧度当作是 π/2 (90°)，而不是 3π/2 (270°)
     *
     * 也就是说，圆心点在南北半球采用相反的极坐标轴，但是这并不影响我们取随机经纬度坐标，反而对编写函数提供了很大的便利。
     */
    private func rad_0Toπ(_ rad: Double, _ len: Double, _ lenToPole: Double) -> GISLatLon {
        let radDiff90 = π_2 - rad
        let logStr = radDiff90 > 0 ? "随机弧度rad: 0 < rad < π/2" : radDiff90 == 0 ? "随机弧度rad = π/2" :"随机弧度rad: π/2 < rad < π"
        logger.info("\(logStr)")
        
        // len等于这个距离的时候，纬度到达最高点，超过这个距离的时候，纬度又开始下降
        let toNearestPoint = lenToPole * cos(abs(radDiff90))  // 距离极点最近的点到当前经纬度点的距离（当 = π/2时，距离极点最近的点就是极点）
        logger.info("距离极点最近的点到当前经纬度点的距离为：\(toNearestPoint)")
        
        let leftLen = len - toNearestPoint  // 超过 toNearestPoint 延伸的长度
        logger.info("leftLen：\(leftLen)")
        
        let nearestPointTo90 = lenToPole * sin(abs(radDiff90))
        logger.info("当前弧度下的射线到最近的极点的距离：\(nearestPointTo90)")
        
        let desToPole = sqrt(leftLen * leftLen + nearestPointTo90 * nearestPointTo90)  // 随机点到最近极点的距离
        logger.info("随机点到最近极点的距离：\(desToPole)")
        let latOffset = (desToPole / DEG2M).roundOff(6)
        let randomLat = centerLatLon.latitude > 0 ? 90 - latOffset : latOffset - 90
        
        let radOffset = asin(abs(leftLen) / desToPole)  // `超过`离极点最近的点之后，所偏移的经度
        logger.info("`超过`离极点最近的点之后，经度偏移弧度：\(radOffset)")
        var lonOffset = (leftLen > 0 ? π_2 - abs(radDiff90) + radOffset : π_2 - abs(radDiff90) - radOffset) * RAD2DEG
        lonOffset = centerLatLon.latitude > 0 ? lonOffset : -lonOffset
        
        let tempLon = radDiff90 >= 0 ? centerLatLon.longitude + lonOffset : centerLatLon.longitude - lonOffset
        let randomLon = parseLonOver180(tempLon)
        
        logger.info("经度偏移角度：\(lonOffset.roundOff(6))")
        logger.info("纬度偏移角度（随机点相对于`最近的极点`）：\(latOffset.roundOff(6))")
        logger.info("随机纬度：\(randomLat) *** 随机经度：\(randomLon)")
        
        return GISLatLon(lat: randomLat, lon: randomLon)
    }
    
    /**
     * 随机弧度rad: π < rad < 2π
     *
     * ⚠️⚠️⚠️（以下说明只针对本函数而言）：
     *
     * 由于只是要在圆内取一个随机点，所以对于随机弧度的取值是多少并不关心，因为本来就是随机的。因此，做如下约定：
     *
     * ➢ 圆心点在北半球或赤道时，圆心点与北极点的连线的弧度当作是 π/2 (90°)
     *
     * ➢ 圆心点在南半球时，圆心点与南极点的连线的弧度当作是 π/2 (90°)，而不是 3π/2 (270°)
     *
     * 也就是说，圆心点在南北半球采用相反的极坐标轴，但是这并不影响我们取随机经纬度坐标，反而对编写函数提供了很大的便利。
     */
    private func rad_πTo2π(_ rad: Double, _ len: Double, _ lenToPole: Double) -> GISLatLon {
        let radDiff270 = π3_2 - rad
        let logStr = radDiff270 > 0 ? "随机弧度rad: π < rad < 3π/2" : radDiff270 == 0 ? "随机弧度rad = 3π/2" : "随机弧度rad: 3π/2 < rad < 2π"
        logger.info("\(logStr)")
        
        let cosLen = cos(abs(radDiff270)) * len
        let sinLen = sin(abs(radDiff270)) * len
        logger.info("cosLen：\(cosLen) *** sinLen：\(sinLen)")
        
        let desToPole = sqrt(sinLen * sinLen + pow(lenToPole + cosLen, 2))  // 随机点到圆心所在半球的极点的距离
        logger.info("随机点到`圆心所在半球`的极点的距离：\(desToPole)")
        let latOffset = (desToPole / DEG2M).roundOff(6)
        let randomLat = centerLatLon.latitude > 0 ? 90 - latOffset : latOffset - 90
        
        let radOffset = asin(sinLen / desToPole)
        logger.info("经度偏移弧度：\(radOffset)")
        let lonOffset = centerLatLon.latitude > 0 ? radOffset * RAD2DEG : -(radOffset * RAD2DEG)
        
        let tempLon = radDiff270 >= 0 ? centerLatLon.longitude - lonOffset : centerLatLon.longitude + lonOffset
        let randomLon = parseLonOver180(tempLon)
        
        logger.info("经度偏移角度：\(lonOffset.roundOff(6))")
        logger.info("纬度偏移角度（随机点相对于`圆心所在半球的极点`）：\(latOffset.roundOff(6))")
        logger.info("随机纬度：\(randomLat) *** 随机经度：\(randomLon)")
        
        return GISLatLon(lat: randomLat, lon: randomLon)
    }
    
    /// 常规算法取随机点，适用于一般情形
    private func commonCase(_ rad: Double, _ len: Double) -> GISLatLon {
        let xOffset = (cos(rad) * len).roundOff(3)
        let yOffset = (sin(rad) * len).roundOff(3)
        logger.info("xOffset：\(xOffset) *** yOffset：\(yOffset)")
        
        let latOffset = yOffset / DEG2M
        let randomLat = (latOffset + centerLatLon.latitude).roundOff(6)
        
        let lonOffset = xOffset / (DEG2M * cos(centerLatLon.latitude * DEG2RAD))
        let tempLon = (lonOffset + centerLatLon.longitude).roundOff(6)
        let randomLon = parseLonOver180(tempLon)
        
        logger.info("经度偏移角度：\(lonOffset) *** 纬度偏移角度：\(latOffset)")
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




