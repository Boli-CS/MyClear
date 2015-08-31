
//
//  File.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-23.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//
import UIKit
class RefreshFooterView: RefreshBaseView {
    
    //响应headView的回调
    var responseToFootView:(()->Void)?
    
    class func footer()->RefreshFooterView{
        var footer:RefreshFooterView  = RefreshFooterView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,
        CGFloat(RefreshViewHeight)))
        
        return footer
    }
    
    var lastRefreshCount:Int = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.statusLabel.frame = self.bounds;
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        if (self.superview != nil){
            self.superview!.removeObserver(self, forKeyPath: RefreshContentSize as String,context:nil)
        }
        if (newSuperview != nil)  {
            newSuperview.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
            // 重新调整frame
           adjustFrameWithContentSize()
        }
    }
    
    //重写调整frame
    func adjustFrameWithContentSize(){
        var contentHeight:CGFloat = self.scrollView.contentSize.height//
        var scrollHeight:CGFloat = self.scrollView.frame.size.height  - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
        var rect:CGRect = self.frame;
        rect.origin.y =  contentHeight > scrollHeight ? contentHeight : scrollHeight
        self.frame = rect;
    }
 
    //监听UIScrollView的属性
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (!self.userInteractionEnabled || self.hidden){
            return
        }
        if RefreshContentSize.isEqualToString(keyPath){
            adjustFrameWithContentSize()
        }else if RefreshContentOffset.isEqualToString(keyPath) {
            adjustStateWithContentOffset()
        }
    }
    
    func adjustStateWithContentOffset()
    {
        var currentOffsetY:CGFloat  = self.scrollView.contentOffset.y
        var happenOffsetY:CGFloat = self.happenOffsetY()
        if currentOffsetY <= happenOffsetY {
            return
        }
        if self.scrollView.dragging {
            var normal2pullingOffsetY =  happenOffsetY + self.frame.size.height
            if self.State == RefreshState.normal && currentOffsetY > normal2pullingOffsetY {
                self.State = RefreshState.pulling;
            } else if (self.State == RefreshState.pulling && currentOffsetY <= normal2pullingOffsetY) {
                self.State = RefreshState.normal;
            }
        } else if (self.State == RefreshState.pulling) {
            self.State = RefreshState.normal
            self.responseToFootView!();
        }
    }

 
    override  var State:RefreshState {
 
    willSet {
        if  State == newValue{
            return;
        }
        oldState = State
    }
    didSet{
        switch State{
        case .normal:
            self.statusLabel.text = RefreshFooterPullToRefresh as String
            self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                self.scrollView.contentInset.bottom = self.scrollViewOriginalInset.bottom
            })
            break
        case .pulling:
            self.statusLabel.text = RefreshFooterPullToRefresh as String
            UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
               self.arrowImage.transform = CGAffineTransformIdentity
                })
            break
        default:
            break

        }
    }
    }
    
    
    func  totalDataCountInScrollView()->Int
    {
        var totalCount:Int = 0
        if self.scrollView is UITableView {
            var tableView:UITableView = self.scrollView as! UITableView
           
            for (var i:Int = 0 ; i <  tableView.numberOfSections() ; i++){
                totalCount = totalCount + tableView.numberOfRowsInSection(i)
                
            }
        } else if self.scrollView is UICollectionView{
          var collectionView:UICollectionView = self.scrollView as! UICollectionView
            for (var i:Int = 0 ; i <  collectionView.numberOfSections() ; i++){
                totalCount = totalCount + collectionView.numberOfItemsInSection(i)
                
            }
        }
        return totalCount
    }
    
    func heightForContentBreakView()->CGFloat
    {
        var h:CGFloat  = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
        return self.scrollView.contentSize.height - h;
    }
    
    
    func happenOffsetY()->CGFloat
    {
        var deltaH:CGFloat = self.heightForContentBreakView()
        if deltaH > 0 {
            return   deltaH - self.scrollViewOriginalInset.top;
        } else {
            return  -self.scrollViewOriginalInset.top;
        }
    }
    
    
     func addState(state:RefreshState){
        self.State = state
    }
    
}