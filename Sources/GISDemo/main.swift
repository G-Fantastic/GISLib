//
//  main.swift
//  GISDemo
//
//  Created by GG on 2019/5/29.
//
import GISLib
import Foundation

GISTools.printGISParams()


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



fileprivate func test1(_ circle1: GISCircle) {
    do{
        try circle1.calculateLatLon(6.283185307179587, 0)
    }catch GISCircleError.radianOver2πError(let msg){
        print(msg)
    }catch GISCircleError.lengthOverRError(let msg){
        print(msg)
    }catch GISCircleError.randomLatLonOutCircleError(let msg){
        print(msg)
    }catch{
        print(error)
    }
}

fileprivate func test2(_ circle1: GISCircle) {
    do{
        try circle1.calculateLatLon(2, 6000)
    }catch GISCircleError.radianOver2πError(let msg){
        print(msg)
    }catch GISCircleError.lengthOverRError(let msg){
        print(msg)
    }catch GISCircleError.randomLatLonOutCircleError(let msg){
        print(msg)
    }catch{
        print(error)
    }
}

fileprivate func test3(_ circle1: GISCircle) {
    
    print(try! circle1.calculateLatLon(6.283185307179586, 0))  // 测试随机弧度为：2π 的处理
    print(try! GISCircle(GISLatLon(lat: 20.903299328, lon: 3.90139109423), 5000).calculateLatLon(2.01, 0))  // 测试随机长度为：0
    print(try! GISCircle(GISLatLon(lat: 90, lon: 3.90139109423), 5000).calculateLatLon(2.01, 0))  // 测试随机长度为：0，且圆心在极点
    print(try! GISCircle(GISLatLon(lat: 90, lon: 3.90139109423), 5000).calculateLatLon(2.01, 20))  // 圆心在极点
    print(try! GISCircle(GISLatLon(lat: -90, lon: 0), 5000).calculateLatLon(2.01, 20))       // 圆心在极点
}

func randomLen(_ r: Double) -> Double {
    return sqrt(Double.random(in: 0...1)) * r
}

fileprivate func test4() {
    let r1 = 5000000.0
    // 随机弧度 = 0 或 = π
    print(try! GISCircle(GISLatLon(lat: -77, lon: 28.3209432432), r1).calculateLatLon(0, randomLen(r1)))
    print(try! GISCircle(GISLatLon(lat: 78.290932, lon: -49.903209), r1).calculateLatLon(3.141592653589793, randomLen(r1)))
    print(try! GISCircle(GISLatLon(lat: -77, lon: 28.3209432432), r1).calculateLatLon(3.141592653589793, randomLen(r1)))
    print(try! GISCircle(GISLatLon(lat: 78.290932, lon: -49.903209), r1).calculateLatLon(0, randomLen(r1)))
}

fileprivate func test5() {
    let r1 = 5000000.0
    let r2 = 10007543.0
    // 随机弧度 = π/2 或 = 3π/2
    print(try! GISCircle(GISLatLon(lat: -67, lon: 28.3209432432), r1).calculateLatLon(1.570796326794897, randomLen(r1)))
    print(try! GISCircle(GISLatLon(lat: 68.290932, lon: -49.903209), r1).calculateLatLon(1.570796326794897, randomLen(r1)))
    print(try! GISCircle(GISLatLon(lat: -50, lon: 28.3209432432), r2).calculateLatLon(4.71238898038469, randomLen(r2)))
    print(try! GISCircle(GISLatLon(lat: 50.290932, lon: -49.903209), r2).calculateLatLon(4.71238898038469, randomLen(r2)))
    
}


fileprivate func test6(_ range: Range<Double>) {
    
    let r1 = 10007543.398010286
    print(try? GISCircle(GISLatLon(lat: -67, lon: 28.3209432432), r1).calculateLatLon(Double.random(in: range), randomLen(r1)))
    print(try? GISCircle(GISLatLon(lat: 68.290932, lon: -49.903209), r1).calculateLatLon(Double.random(in: range), randomLen(r1)))
    print(try? GISCircle(GISLatLon(lat: -17, lon: 28.3209432432), r1).calculateLatLon(Double.random(in: range), randomLen(r1)))
    print(try? GISCircle(GISLatLon(lat: 88.290932, lon: -179.903209), r1).calculateLatLon(Double.random(in: range), randomLen(r1)))
    print(try? GISCircle(GISLatLon(lat: -85.90323232423, lon: 28.3209432432), r1).calculateLatLon(Double.random(in: range), randomLen(r1)))
    print(try? GISCircle(GISLatLon(lat: 10.290932, lon: 179.903209), r1).calculateLatLon(Double.random(in: range), randomLen(r1)))

    let r2 = 5007543.0
    print(try? GISCircle(GISLatLon(lat: -50, lon: 28.3209432432), r2).calculateLatLon(Double.random(in: range), randomLen(r2)))
    print(try? GISCircle(GISLatLon(lat: 50.290932, lon: -49.903209), r2).calculateLatLon(Double.random(in: range), randomLen(r2)))
    print(try? GISCircle(GISLatLon(lat: -67, lon: 28.3209432432), r1).calculateLatLon(Double.random(in: range), randomLen(r2)))
    print(try? GISCircle(GISLatLon(lat: 88.290932, lon: -179.903209), r1).calculateLatLon(Double.random(in: range), randomLen(r2)))
    print(try? GISCircle(GISLatLon(lat: -85.90323232423, lon: 28.3209432432), r1).calculateLatLon(Double.random(in: range), randomLen(r2)))
    print(try? GISCircle(GISLatLon(lat: 70.290932, lon: 179.903209), r1).calculateLatLon(Double.random(in: range), randomLen(r2)))
    
    
}

fileprivate func test7() {
    print(try? GISCircle(GISLatLon(lat: 0, lon: 179.3209432432), 10007543.398010286).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 0, lon: 179.3209432432), 10007543.398010286).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 0, lon: 179.3209432432), 10007543.398010286).randomLatLon())
    
    let r: Double = 5000000.0
    print("\n圆的半径：\(r)")
    print(try? GISCircle(GISLatLon(lat: -43.9249832432423, lon: 28.3209432432), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 43.9249832432423, lon: 179), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -35.9249832432423, lon: -179.3209432432), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 35.9249832432423, lon: -168.3209432432), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -25.9249832432423, lon: 168.3209432432), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 25.9249832432423, lon: 28.3209432432), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -10.9249832432423, lon: 28.3209432432), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 10.9249832432423, lon: 28.3209432432), r).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 0, lon: 28.3209432432), r).randomLatLon())

    
    let r1: Double = 1000000.0
    print("\n圆的半径：\(r1)")
    print(try? GISCircle(GISLatLon(lat: -80.9249832432423, lon: 28.3209432432), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 80.9249832432423, lon: 179), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -71.9249832432423, lon: -179.3209432432), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 60.9249832432423, lon: 28.3209432432), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -50.9249832432423, lon: 0), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 25.9249832432423, lon: -168.3209432432), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -10.9249832432423, lon: 168.3209432432), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 10.9249832432423, lon: 28.3209432432), r1).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 0, lon: 28.3209432432), r1).randomLatLon())


    let r2: Double = 500000.0
    print("\n圆的半径：\(r2)")
    print(try? GISCircle(GISLatLon(lat: -84.9249832432423, lon: 28.3209432432), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 84.9249832432423, lon: 179), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -70.9249832432423, lon: -179.3209432432), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 80.9249832432423, lon: 28.3209432432), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -50.9249832432423, lon: 0), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 60.9249832432423, lon: -168.3209432432), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: -10.9249832432423, lon: 168.3209432432), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 10.9249832432423, lon: 28.3209432432), r2).randomLatLon())
    print(try? GISCircle(GISLatLon(lat: 0, lon: 28.3209432432), r2).randomLatLon())
    
}


func testRandomLatLon() {
    let circle1 = GISCircle(GISLatLon(), 5000)
//    test1(circle1)  // 测试异常：radianOver2πError
//    test2(circle1)  // 测试异常：lengthOverRError
//    test3(circle1)  // 特殊点测试
//    test4()         // 极点在圆内 随机弧度 = 0 或 = π
//    test5()         // 极点在圆内 随机弧度 = π/2 或 = 3π/2
//    test6(0..<3.141592653589793)           // 极点在圆内 随机弧度 (0, π)
//    test6(3.141592653589793..<6.283185307179586)           // 极点在圆内 随机弧度 (π, 2π)
    test7() // 普通测试
    
    
}


testRandomLatLon()



