//
//  ViewController.swift
//  GCD
//
//  Created by Hiếu Nguyễn on 8/10/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        serrialQueue()
//        concurrentQueue()
//        racingData()
//        disPatchQueueAsyncAfter()
//        disPatchWorkItem()
        doSomething()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func serrialQueue() {
        let serrialQueue = DispatchQueue(label: "com.bigZero.SerrialQeue")
        for i in 0...5 {
            serrialQueue.async {
                print("\(i): - \(Thread.current)")
                sleep(1)
            }
        }
        print("Completed: - \(Thread.current)")
    }
    func concurrentQueue() {
        let concurrentQueue = DispatchQueue(label: "com.bigZero.concurrentQueue", attributes: .concurrent)
        for i in 0...5 {
            concurrentQueue.async {
                print("\(i): - \(Thread.current)")
                sleep(1)
            }
        }
        print("Complete: - \(Thread.current)")
    }
    func racingData() {
        var count = 0
//        for _ in 0...40000 {
//            DispatchQueue.global().async {
//                count += 1
//            }
//        }
//        print(count)
        DispatchQueue.global().async {
            for _ in 0...40000 {
                count += 1
            }
            DispatchQueue.main.async {
                print(count)
            }
        }
        print(count)
    }
    func demo() {
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                
            }
        }
    }
    func disPatchQueueAsyncAfter() {
        for i in 0...5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("\(i): - \(Thread.current)")
            }
        }
        print("Completed: - \(Thread.current)")
    }
    func disPatchWorkItem() {
        var count = 0
        let disPatchWorkItem = DispatchWorkItem {
            count += 1
            print("\(count): - \(Thread.current)")
        }
        for _ in 0...1000 {
            if count == 900 {
                disPatchWorkItem.cancel()
                print("Dispatch Work Item is cancel")
                
            } else {
                disPatchWorkItem.perform()
            }
        }
    }
    
}



func getSumOf(numbers: [Int], completion: @escaping (Int) -> Void) {
    // 2. Excute function.
    var sum = 0
    for aNumber in numbers {
        sum += aNumber
    }
    
    // Delay 5s và excute closure trên global queue.
    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
        completion(sum)
    }
    
}
func doSomething() {
    // 1. Gọi function, truyền closure vào làm tham số.
    getSumOf(numbers: [34, 16, 231, 6 , 23, -83]) { result in
        print("Sum is \(result)")
        // 4. Closure được excute xong, return compiler và closure chưa bị giải phóng vì đang được giữ lại trên queue khác để excute sau.
    }
    
}

