//
//  GISLib.swift
//  GISLib
//
//  Created by GG on 2019/5/29.
//

/// 圆周率π
internal let π = Double.pi
/// π的1/2
internal let π_2 = (π / 2).roundOff(15)
/// π的3/2
internal let π3_2 = (3 * π / 2).roundOff(15)
/// π的2倍
internal let π2 = (2 * π).roundOff(15)
/// 地球平均半径。  单位：m（米）
internal let EARTH_R = 6371000.0
/// 地球赤道周长(circumference)。  单位：m（米）
internal let CIRCUM = π2 * EARTH_R
/// 地球赤道周长的1/4。   单位：m（米）
internal let CIRCUM_4 = CIRCUM / 4
/// 地球赤道周长的1/8。   单位：m（米）
internal let CIRCUM_8 = CIRCUM / 8
/// 角度转弧度的系数。
internal let DEG2RAD = π / 180
/// 弧度转角度的系数。
internal let RAD2DEG = 180 / π
/// 1°纬度所对应的距离。   单位：m（米）
internal let DEG2M = 111194.927


