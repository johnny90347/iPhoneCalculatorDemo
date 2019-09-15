//
//  CalculatorViewController.swift
//  iPhoneCalculatorDemo
//
//  Created by 梁鑫文 on 2019/9/13.
//  Copyright © 2019 Johhny. All rights reserved.
//

import UIKit

enum OperationType{ //計算種類
    case add        //+
    case subtract   //-
    case multiply   //x
    case divide     //÷
    case none       //沒有
}

class CalculatorViewController: UIViewController {
    
    
    var numberOnScreen:Double = 0     //計算機螢幕上的數字
    var previousNumber:Double = 0     //將數字儲存準備下回合的運算
    var performingMath = false        //是否開始計數
    var isPointCalulate = false       //小數點的使用,一次畫面只有一個.
    var isNegative = false            //是負數
    var operation:OperationType = .none
    
    
    @IBOutlet weak var showLabel: UILabel!       //顯示畫面
    
    @IBOutlet var calculateButtons: [UIButton]!  //全部的數字按鈕和計算按鈕
    
    @IBOutlet weak var equalButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in calculateButtons{
            button.layer.cornerRadius = button.frame.height / 2
        }
        
    }
    
    

    
    //計算按鈕群
    @IBAction func CalculateButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 10 && isPointCalulate == false {     //小數點符號
            
            if performingMath == false {
                showLabel.text = "0" + "."
            }else{
                showLabel.text = showLabel.text! + "."
            }
            isPointCalulate = true
            performingMath = true
        }
       
        if sender.tag == 11 {   // =

            if performingMath == true {
                calculation()
                previousNumber = 0
            }
        }
        
        
        if sender.tag == 12 {  // +
            
            if performingMath == true {
                calculation()
                
            }
            
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            operation = .add
            
            print("+")
        }
        
        if sender.tag == 13 {  // -
            if performingMath == true {
                calculation()
            }
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            operation = .subtract
            print("-")
        }
        
        if sender.tag == 14 {  // x
            if performingMath == true {
                calculation()
            }
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            operation = .multiply
            print("x")
        }
        if sender.tag == 15 {  // ÷
            if performingMath == true {
                calculation()
            }
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            operation = .divide
            print("÷")
        }
        
        if sender.tag == 16 {  // %
            print("%")
            numberOnScreen = (Double(showLabel.text!)!)/100
            transferNumberToString(form: numberOnScreen)
            specialSymbolBackgroundColorAnimate(sender)
        }
        
        if sender.tag == 17 {  // +/- 轉換
            
            if isNegative == false{
                numberOnScreen = -Double(showLabel.text!)!
                if numberOnScreen == 0{
                    showLabel.text = "-" + "0"
                }else{
                    transferNumberToString(form: numberOnScreen)
                }
                isNegative = true
            }else{
                numberOnScreen = -Double(showLabel.text!)!
                transferNumberToString(form: numberOnScreen)
                isNegative = false
            }
            specialSymbolBackgroundColorAnimate(sender)
            print("+/-")
        }
        
        if sender.tag == 18 {    //AC
            showLabel.text = "0"
            numberOnScreen = 0
            previousNumber = 0
            operation = .none
            isPointCalulate = false
            performingMath = false
            specialSymbolBackgroundColorAnimate(sender)
           equalButton.setTitle("AC", for: .normal)
        }
        
       
        
    }
    
    
    
    //數字按鈕群
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        numberButtonBackgroundColorAnimate(sender)
        equalButton.setTitle("C", for: .normal)
        if performingMath == false{
            showLabel.text = String(sender.tag)
            performingMath = true
            numberOnScreen = Double(showLabel.text!)!
            }else{
            showLabel.text = (showLabel.text)! + String(sender.tag)
            numberOnScreen = Double(showLabel.text!)!
            transferNumberToString(form: numberOnScreen)
            
            }

        print(numberOnScreen)
        
    
    }
    
    
    func transferNumberToString(form number:Double){    //如果沒有小數點則呈現整數
        
        var okString:String
        
        if floor(number) == number {
            okString = "\(Int(number))"
        }else{
            okString = "\(number)"
        }
        
        if okString.count >= 9 {
            okString = String(okString.prefix(9))
        }
        
        showLabel.text = okString
    }
    
    func calculation(){     //計算結果
        switch operation{
            
        case .add:        //+
            numberOnScreen = previousNumber + numberOnScreen
            transferNumberToString(form: numberOnScreen)
            performingMath = false
            isPointCalulate = false
            
        case .subtract:  //-
            numberOnScreen = previousNumber - numberOnScreen
            transferNumberToString(form: numberOnScreen)
            performingMath = false
            isPointCalulate = false
            
        case .multiply:  //x
            numberOnScreen = previousNumber * numberOnScreen
            transferNumberToString(form: numberOnScreen)
            performingMath = false
            isPointCalulate = false
            
        case .divide:   //÷
            numberOnScreen = previousNumber / numberOnScreen
            transferNumberToString(form: numberOnScreen)
            performingMath = false
            isPointCalulate = false
            
        case .none:
            break
        }
    }
    
    
  
    
    //按下數字鍵 0~9 . 的動畫
    func numberButtonBackgroundColorAnimate(_ sender: UIButton){
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
             sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        let animatorTwo = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            sender.backgroundColor = #colorLiteral(red: 0.4341813624, green: 0.442956984, blue: 0.4732919335, alpha: 1)
        }
        animator.addCompletion { _ in
            animatorTwo.startAnimation()
        }
        animator.startAnimation()
        
    }
    
    //按下特殊符號 AC % +/- 的動畫
    func specialSymbolBackgroundColorAnimate(_ sender: UIButton){
        
        
        let otherAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            sender.backgroundColor = #colorLiteral(red: 0.9096873403, green: 0.9096873403, blue: 0.9096873403, alpha: 1)
        }
        otherAnimator.startAnimation()
        let otherAnimatorTwo = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            sender.backgroundColor = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
        }
        otherAnimator.addCompletion { _ in
            otherAnimatorTwo.startAnimation()
        }
        
    }
    
    func calculationSymbolBackgroundColorAnimate(_ sender: UIButton, int:Int){
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        animator.addAnimations({
        let button = sender.viewWithTag(int) as! UIButton
        button.setTitleColor(#colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1), for: .normal)
        }, delayFactor: 0)
        animator.startAnimation()
        
    }
    //沒用
    func calculationSymbolOriginColorAnimate(_ sender: UIButton, int:Int){
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        }
        
        animator.addAnimations({
            let button = sender.viewWithTag(int) as! UIButton
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }, delayFactor: 0)
        animator.startAnimation()
        
    }

}
