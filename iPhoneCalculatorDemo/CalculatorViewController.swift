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
    var operationCurrentTitle:String = ""   //目前正在使用的運算符號 ""代表沒有運算
    
    
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
        
        if sender.tag == 10{  //小數點
            numberButtonBackgroundColorAnimate(sender)
        }
        
        if sender.tag == 10 && isPointCalulate == false {     //小數點符號使用
            
            
            if performingMath == false {
                showLabel.text = "0" + "."
            }else{
                showLabel.text = showLabel.text! + "."
            }
            isPointCalulate = true
            performingMath = true
        }
       
        if sender.tag == 11 {   // =
           
            
            if performingMath == true{
                calculation()
                previousNumber = 0
                performingMath = false
            }
            

        }
        
        if sender.tag == 12 {  // +
            if operationCurrentTitle != "+" {
                calculationSymbolBackgroundColorAnimate(sender, int: sender.tag)
                checkAnyCalculateSymbolIsExist()
                operationCurrentTitle = "+"
            }
        
            if performingMath == true {
                calculation()
            }
            
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            isNegative = false
            operation = .add
            print("+")
        }
        
        if sender.tag == 13 {  // -
            if operationCurrentTitle != "-" {
                calculationSymbolBackgroundColorAnimate(sender, int: sender.tag)
                checkAnyCalculateSymbolIsExist()
                operationCurrentTitle = "-"
            }
            
            if performingMath == true {
                calculation()
            }
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            isNegative = false
            operation = .subtract
            print("-")
        }
        
        if sender.tag == 14 {  // x
            if operationCurrentTitle != "x" {
                calculationSymbolBackgroundColorAnimate(sender, int: sender.tag)
                checkAnyCalculateSymbolIsExist()
                operationCurrentTitle = "x"
                isNegative = false
            }
            
            if performingMath == true {
                calculation()
            }
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            isNegative = false
            operation = .multiply
            print("x")
        }
        if sender.tag == 15 {  // ÷
            if operationCurrentTitle != "÷" {
                calculationSymbolBackgroundColorAnimate(sender, int: sender.tag)
                checkAnyCalculateSymbolIsExist()
                operationCurrentTitle = "÷"

            }
            
            if performingMath == true {
                calculation()
            }
            previousNumber = numberOnScreen
            performingMath = false
            isPointCalulate = false
            isNegative = false
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
            isNegative = false
            specialSymbolBackgroundColorAnimate(sender)
            equalButton.setTitle("AC", for: .normal)
            checkAnyCalculateSymbolIsExist()
        }
        
        
        
        
        //數字按鈕群
        switch sender.tag {
        case 0...9:
            
            if operationCurrentTitle != "" {
                changeCalculateBackgroundColor( ChagecurrentitleTo: "")
            }
            
            numberButtonBackgroundColorAnimate(sender)
            equalButton.setTitle("C", for: .normal)
            if performingMath == false{
                showLabel.text = String(sender.tag)
                
                if isNegative == true {
                    showLabel.text = "-\(sender.tag)"
                }
                
                performingMath = true
                numberOnScreen = Double(showLabel.text!)!
            }else{
                if showLabel.text!.count >= 9 {  //能輸入的數字只能小於9位數
                    break
                }
                showLabel.text = (showLabel.text)! + String(sender.tag)
                numberOnScreen = Double(showLabel.text!)!
            
            }
            
            print(numberOnScreen)
        default:
            break
        }
       
    }
    
    func checkAnyCalculateSymbolIsExist(){
        if operationCurrentTitle != ""{
            for button in calculateButtons {
                if button.currentTitle == operationCurrentTitle{
                    calculationSymbolOriginColorAnimate(button: button)
                }
            }
        }
    }
    
    
    //判斷是不是要恢復 + - x ÷ 的背景顏色
    func changeCalculateBackgroundColor(ChagecurrentitleTo title:String){
        
        for button in calculateButtons {
            if button.currentTitle == "+" ||
                button.currentTitle == "-"  ||
                button.currentTitle == "x"  ||
                button.currentTitle == "÷"
            {
                calculationSymbolOriginColorAnimate(button: button)
                operationCurrentTitle = title
            }
        }
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
            sender.backgroundColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)
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
            sender.backgroundColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        }
        otherAnimator.addCompletion { _ in
            otherAnimatorTwo.startAnimation()
        }
        
    }
    
    //按下計算符號 閃一下 的動畫 (用在已經
    func calculationSymbolFlashAnimate(_ sender: UIButton){
        
        
        let otherAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            sender.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        otherAnimator.startAnimation()
        let otherAnimatorTwo = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        }
        otherAnimator.addCompletion { _ in
            otherAnimatorTwo.startAnimation()
        }
        
    }
    
    
    
    // + - x ÷ 的背景色變白色
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
    //+ - x ÷ 的背景色變橘色
    func calculationSymbolOriginColorAnimate(button: UIButton){
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        }
        
        animator.addAnimations({
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }, delayFactor: 0)
        animator.startAnimation()
        
    }
    
    

}
