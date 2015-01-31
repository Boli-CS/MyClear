//
//  RefreshHeaderView.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-24.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//

import UIKit
class RefreshHeaderView: RefreshBaseView {
    class func footer()->RefreshHeaderView{
        var footer:RefreshHeaderView  = RefreshHeaderView(frame: CGRectMake(0, 0,   UIScreen.mainScreen().bounds.width,  CGFloat(RefreshViewHeight)))
        return footer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var statusX:CGFloat = 0
        var statusY:CGFloat = 0
        var statusHeight:CGFloat = self.frame.size.height * 0.5
        var statusWidth:CGFloat = self.frame.size.width
        //状态标签
        self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight)
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
         // 设置自己的位置和尺寸
        var rect:CGRect = self.frame
        rect.origin.y = -self.frame.size.height
        self.frame = rect
    }
    
    //监听UIScrollView的contentOffset属性
    override  func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
        if (!self.userInteractionEnabled || self.hidden){
            return
        }
        if RefreshContentOffset.isEqualToString(keyPath){
            self.adjustStateWithContentOffset()
        }
    }
    
    //调整状态
    func adjustStateWithContentOffset()
    {
        var currentOffsetY:CGFloat = self.scrollView.contentOffset.y
        var happenOffsetY:CGFloat = -self.scrollViewOriginalInset.top
        if (currentOffsetY >= happenOffsetY) {
            return
        }
        if self.scrollView.dragging{
            var normal2pullingOffsetY:CGFloat = happenOffsetY - self.frame.size.height
            if  self.State == RefreshState.Normal && currentOffsetY < normal2pullingOffsetY{
                self.State = RefreshState.Pulling
            }else if self.State == RefreshState.Pulling && currentOffsetY >= normal2pullingOffsetY{
                self.State = RefreshState.Normal
            }
        }else if self.State == RefreshState.Pulling {
            self.State = RefreshState.back
        }
    }
    
    //设置状态
    override  var State:RefreshState {
    willSet {
        if  State == newValue{
            return;
        }
        oldState = State
        setState(newValue)
    }
    didSet{
        switch State{
        case .Normal:
            self.statusLabel.text = RefreshHeaderPullToRefresh
            UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                self.arrowImage.transform = CGAffineTransformIdentity
            })
            break
        case .Pulling:
            self.statusLabel.text = RefreshHeaderReleaseToRefresh
            UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI ))
            })
            break
        default:
            break
            
        }
    }
    }
    
    func addState(state:RefreshState){
        self.State = state
    }
}
    