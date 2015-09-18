//
//  RefreshBaseView.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-23.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//
import UIKit

//控件的刷新状态
enum RefreshState {
    case pulling    //松开返回正常状态
    case addNewItem // 松开就增加新的元素状态
    case normal     // 普通状态
    case back       //返回上一级
    case jump       //跳转到下一个view
}

//控件的类型
enum RefreshViewType {
    case  TypeHeader             // 头部控件
    case  TypeFooter             // 尾部控件
}

let RefreshLabelTextColor:UIColor = UIColor(red: 150.0/255, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1)


class RefreshBaseView: UIView {
    
 
    //  父控件
    var scrollView:UIScrollView!
    var scrollViewOriginalInset:UIEdgeInsets!
    
    // 内部的控件
    var statusLabel:UILabel!
    var arrowImage:UIImageView!
    
    // 交给子类去实现 和 调用
    var  oldState:RefreshState?
    
    var State:RefreshState = RefreshState.normal{
        willSet{
        }
        didSet{
            
        }
        
    }
    
    //控件初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        //状态标签
        statusLabel = UILabel()
        statusLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        statusLabel.font = UIFont.boldSystemFontOfSize(13)
        statusLabel.textColor = RefreshLabelTextColor
        statusLabel.backgroundColor =  UIColor.clearColor()
        statusLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(statusLabel)
        //箭头图片
        arrowImage = UIImageView(image: UIImage(named: "arrow.png"))
        arrowImage.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        self.addSubview(arrowImage)

         //自己的属性
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        //设置默认状态
        self.State = RefreshState.normal;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
         //箭头
        let arrowX:CGFloat = self.frame.size.width * 0.5 - 100
        self.arrowImage.center = CGPointMake(arrowX, self.frame.size.height * 0.5)
    }
    
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        // 旧的父控件
         
        if (self.superview != nil) {
            self.superview?.removeObserver(self, forKeyPath: RefreshContentSize as String, context: nil)
            
            }
        // 新的父控件
        if (newSuperview != nil) {
            newSuperview.addObserver(self, forKeyPath: RefreshContentOffset as String, options: NSKeyValueObservingOptions.New, context: nil)
            var rect:CGRect = self.frame
            // 设置宽度   位置
            rect.size.width = newSuperview.frame.size.width
            rect.origin.x = 0
            self.frame = frame;
            //UIScrollView
            scrollView = newSuperview as! UIScrollView
            scrollViewOriginalInset = scrollView.contentInset;
        }
    }
    
    //显示到屏幕上
    override func drawRect(rect: CGRect) {
        superview?.drawRect(rect);
    }
    
    
    //结束刷新
    func endRefreshing(){
        let delayInSeconds:Double = 0.3
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds));
        
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.State = RefreshState.normal;
            })
    }
}







