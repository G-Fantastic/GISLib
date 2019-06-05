//
//  main.swift
//  GISDemo
//
//  Created by GG on 2019/5/29.
//
import GISLib

//GISTools.printGISParams()


func testDistance() {
    // 测试 distance 方法
    print("测试 distance 方法")
    print(GISTools.distance(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: 1, lon: 0)))          // 111194.927
    print(GISTools.distance(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: -1, lon: 0)))         // 111194.927
    print(GISTools.distance(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: 0, lon: 1)))          // 111194.927
    print(GISTools.distance(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: 0, lon: -1)))         // 111194.927
    print(GISTools.distance(GISLatLon(lat: 0, lon: -179), GISLatLon(lat: 0, lon: 179)))     // 222389.853
    print(GISTools.distance(GISLatLon(lat: 0, lon: -1), GISLatLon(lat: 0, lon: 1)))         // 222389.853
    print(GISTools.distance(GISLatLon(lat: 0, lon: -1), GISLatLon(lat: 0, lon: -2)))        // 111194.927
    print(GISTools.distance(GISLatLon(lat: 0, lon: -2), GISLatLon(lat: 0, lon: -1)))        // 111194.927
    print(GISTools.distance(GISLatLon(lat: 50, lon: -2), GISLatLon(lat: 50, lon: -1)))      // 71474.189
    print(GISTools.distance(GISLatLon(lat: 50, lon: -1), GISLatLon(lat: 50, lon: -2)))      // 71474.189
    print(GISTools.distance(GISLatLon(lat: -89, lon: -2), GISLatLon(lat: -89, lon: -1)))    // 1940.594
    print(GISTools.distance(GISLatLon(lat: 89, lon: -1), GISLatLon(lat: 89, lon: -2)))      // 1940.594
    print(GISTools.distance(GISLatLon(lat: 1, lon: -90), GISLatLon(lat: 2, lon: -90)))      // 111194.927
    print(GISTools.distance(GISLatLon(lat: -1, lon: 90), GISLatLon(lat: -2, lon: 90)))      // 111194.927
    print(GISTools.distance(GISLatLon(lat: 90, lon: 0), GISLatLon(lat: 89, lon: 0)))        // 111194.927
    print(GISTools.distance(GISLatLon(lat: 90, lon: 0), GISLatLon(lat: 89, lon: 180)))      // 111194.927
    print(GISTools.distance(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 180)))      // 222389.853
    print(GISTools.distance(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: -180)))     // 222389.853
    print(GISTools.distance(GISLatLon(lat: 50, lon: 0), GISLatLon(lat: 90, lon: -180)))     // 4447797.066
    print(GISTools.distance(GISLatLon(lat: 50, lon: 0), GISLatLon(lat: 90, lon: 0)))        // 4447797.066
    print(GISTools.distance(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 1)))        // 1940.594
    print(GISTools.distance(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 2)))        // 3881.041
    print(GISTools.distance(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 179)))      // 222381.385
    print(GISTools.distance(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 180)))      // 222389.853

}

func testDistanceWithAltitude(){
    
    // 测试 distanceWithAltitude 方法
    print("\n测试 distanceWithAltitude 方法")
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 0, lon: -1), GISLatLon(lat: 0, lon: 1), 0, 0))         // 222389.853
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 0, lon: -1), GISLatLon(lat: 0, lon: -2), 0, 0))        // 111194.927
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 0, lon: -2), GISLatLon(lat: 0, lon: -1), 0, 0))        // 111194.927
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 50, lon: -2), GISLatLon(lat: 50, lon: -1), 0, 0))      // 71474.189
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 50, lon: -1), GISLatLon(lat: 50, lon: -2), 0, 0))      // 71474.189
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 50, lon: 0), GISLatLon(lat: 90, lon: -180), 0, 0))     // 4447797.066
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 50, lon: 0), GISLatLon(lat: 90, lon: 0), 0, 0))        // 4447797.066
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 1), 0, 0))        // 1940.594
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 2), 0, 0))        // 3881.041
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 179), 0, 0))      // 222381.385     ➀
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 180), 0, 0))      // 222389.853     ➁
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: 0, lon: 1), 0, 0))          // 111194.927     ➂
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: 0, lon: 2), 0, 0))          // 222389.853     ➃
    print("带海拔")
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 179), 1000, 0))   // 222383.633     ➊
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 89, lon: 0), GISLatLon(lat: 89, lon: 180), 6000, 0))   // 222470.778     ➋
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: 0, lon: 1), 0, 1000))       // 111199.423     ➌
    print(GISTools.distanceWithAltitude(GISLatLon(lat: 0, lon: 0), GISLatLon(lat: 0, lon: 2), 0, 5000))       // 222446.054     ➍
    
    // ➀ 与 ➊ 对比，➁ 与 ➋ 对比，➂ 与 ➌ 对比，➃ 与 ➍ 对比
}

//testDistance()
//testDistanceWithAltitude()

var circle = GISCircle(GISLatLon(lat: -20.132, lon: 0.19032), 3000)
try! circle.randomLatLon()


