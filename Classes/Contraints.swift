//
//  Countraints.swift
//  chata
//
//  Created by Vicente Rincon on 21/10/20.
//

import Foundation
import UIKit
public enum DViewSafeArea: String, CaseIterable {
    case topHeight, alignViewLeft, leftRightView, none, noneAsymetric, widthLeft , widthRight, full, fullStack, fullLimit, fullWidth, leftBottom, rightTop, rightBottom, fullStatePaddingAll, rightCenterY, safe , safeChatRight, safeChatLeft, safeChatTop, safeChatBottom, safeButtons, safeButtonsLeft, safeButtonsTop, safeButtonsBottom, safeFHRight, safeFHLeft, safeFHTop, safeFHBottom, leftCenterY, fullState, bottomTop, center, leftAdjust, padding, paddingTop, rightMiddle = "right", leftMiddle = "left", topMiddle = "top", bottomMiddle = "bottom", fullBottom, fullBottomCenter, paddingTopLeft, paddingTopRight, modal, modalLeft, modalRight, dropDownUp, secondTop, midTopBottom, midTopBottom2, bottomPorcent, fullPadding, topHeightFixPadding, topHeightPadding, dropDownBottomHeight, dropDownBottomHeightLeft, bottomHeightFixPadding, bottomRight,
        noneTopPadding, fullStackH, fullStatePadding, bottomHeight, fullStackV, dropDown, dropDownTop, dropDownTopHeight,dropDownTopHeightLeft, centerSize, bottomSize, centerSizeUp, noneBottom
    static func withLabel(_ str: String) -> DViewSafeArea? {
        return self.allCases.first {
            "\($0.description)" == str
        }
    }
    var description: String {
        return self.rawValue
    }
}
extension UIView {
    private enum sideConst: String{
        case top, bottom, right, left, topBottom, bottomTop, centerX, centerY, width, height, rightLeft, leftRight, heightMultiplier
    }
    private enum sideType: String {
        case less, greater, equal
    }
    @discardableResult
    public func edgeTo(_ view: UIView,
                       safeArea: DViewSafeArea = .none,
                       height: CGFloat = 0,
                       width: CGFloat = 0,
                       _ secondView: UIView = UIView(),
                       _ bottomView: UIView = UIView(),
                       padding: CGFloat = 0,
                       secondPadding: CGFloat = 0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        var finalPadding = paddingConst()
        finalPadding.height = height
        finalPadding.width = height
        finalPadding.centerY = secondPadding
        finalPadding.top = padding
        finalPadding.left = padding
        finalPadding.right = -padding
        finalPadding.bottom = -padding
        switch safeArea {
        case .topHeight:
            getConst(view: view, side: .top, padding: finalPadding.top)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .leftRightView:
            getConst(view: view, side: .top, padding: finalPadding.top)
            getConst(view: view, side: .left, padding: finalPadding.left)
            getConst(view: secondView, side: .right, padding: finalPadding.right)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .midTopBottom2:
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top)
            getConst(view: secondView, side: .right, padding: finalPadding.right)
            getConst(view: secondView, side: .left, padding: finalPadding.left)
            getConst(view: view, side: .bottom, padding: finalPadding.bottom)
        case .midTopBottom:
            getConst(view: view, side: .left, padding: finalPadding.left)
            getConst(view: secondView, side: .rightLeft, padding: finalPadding.right)
            getConst(view: view, side: .height, padding: height)
            getConst(view: view, side: .top, padding: finalPadding.top)
            
            
        /*case .midTopBottom3:
            getConst(view: view, side: .bottom, padding: finalPadding.bottom)
            getConst(view: secondView, side: .left, padding: finalPadding.left)
            getConst(view: secondView, side: .right, padding: finalPadding.right)
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top)*/
        case .bottomPorcent:
            getConst(view: view, side: .heightMultiplier, padding: finalPadding.height)
            sideSymetric(view: secondView, padding: finalPadding.left)
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top)
        case .bottomHeight:
            getConst(view: view, side: .bottom, padding: secondPadding > 0 ? -secondPadding : finalPadding.bottom)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .bottomSize:
            getConst(view: view, side: .bottom, padding: finalPadding.bottom)
            getConst(view: view, side: .left, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
            getConst(view: view, side: .width, padding: finalPadding.height * 2)
        case .bottomTop:
            getConst(view: secondView, side: .bottomTop, padding: finalPadding.bottom)
            sideSymetric(view: secondView, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .none:
            sideSymetric(view: view, padding: finalPadding.left)
            sideSymetric(view: view, padding: finalPadding.top, vertical: true)
        case .noneBottom:
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .top, padding: finalPadding.top)
            getConst(view: view, side: .bottom, padding: -secondPadding)
        case .noneAsymetric:
            getConst(view: view, side: .left, padding: finalPadding.left)
            getConst(view: view, side: .right, padding: finalPadding.centerY)
            sideSymetric(view: view, padding: finalPadding.centerY, vertical: true)
        case .widthLeft:
            getConst(view: view, side: .top, padding: finalPadding.top)
            getConst(view: view, side: .left, padding: finalPadding.left)
            sizeSymetric(view: view, size: finalPadding.height)
        case .widthRight:
            getConst(view: view, side: .right, padding: finalPadding.right)
            sizeSymetric(view: view, size: finalPadding.height)
            getConst(view: view, side: .centerY, padding: -finalPadding.centerY)
        case .safe:
            sideSymetric(view: view, padding: finalPadding.left, vertical: true, safe: true)
            sideSymetric(view: view, padding: finalPadding.left, vertical: false, safe: true)
        case .safeButtons:
            getConst(view: view, side: .centerY, padding: -finalPadding.centerY)
            getConst(view: secondView, side: .rightLeft, padding: 1)
            getConst(view: view, side: .left, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .safeButtonsLeft:
            getConst(view: view, side: .centerY, padding: -finalPadding.centerY)
            getConst(view: secondView, side: .leftRight, padding: -1)
            getConst(view: view, side: .right, padding: finalPadding.right)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .safeButtonsTop:
            getConst(view: view, side: .centerX, padding: finalPadding.centerX)
            getConst(view: secondView, side: .topBottom, padding: -1)
            getConst(view: view, side: .bottom, padding: finalPadding.top, safe: true)
            getConst(view: view, side: .width, padding: finalPadding.height)
        case .safeButtonsBottom:
            getConst(view: view, side: .centerX, padding: finalPadding.centerX)
            getConst(view: view, side: .top, padding: finalPadding.top)
            getConst(view: secondView, side: .bottomTop, padding: 1)
            getConst(view: view, side: .width, padding: finalPadding.height)
        case .safeFHRight:
            getConst(view: view, side: .left, padding: finalPadding.left, safe: true)
            getConst(view: secondView, side: .rightLeft, padding: finalPadding.right)
            sideSymetric(view: view, padding: 0, vertical: true, safe: true)
        case .safeFHLeft:
            sideSymetric(view: view, padding: 0, vertical: true, safe: true)
            getConst(view: secondView, side: .leftRight, padding: finalPadding.left, safe: true)
            getConst(view: view, side: .right, padding: finalPadding.right)
        case .safeFHTop:
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top, safe: true)
            sideSymetric(view: view, padding: 0, safe: true)
            getConst(view: view, side: .bottom, padding: finalPadding.bottom)
        case .safeFHBottom:
            getConst(view: view, side: .top, padding: finalPadding.top)
            sideSymetric(view: view, padding: 0, safe: true)
            getConst(view: secondView, side: .bottomTop, padding: finalPadding.bottom)
        case .safeChatRight:
            getConst(view: view, side: .left, padding: finalPadding.left, safe: true)
            getConst(view: view, side: .right, safe: true)
            sideSymetric(view: view, padding: 0, vertical: true, safe: true)
        case .safeChatLeft:
            sideSymetric(view: view, padding: 0, vertical: true, safe: true)
            getConst(view: view, side: .left, safe: true)
            getConst(view: view, side: .right, padding: finalPadding.right, safe: true)
        case .safeChatTop:
            getConst(view: view, side: .top, safe: true)
            sideSymetric(view: view, padding: 0, safe: true)
            getConst(view: view, side: .bottom, padding: finalPadding.bottom, safe: true)
        case .safeChatBottom:
            getConst(view: view, side: .top, padding: finalPadding.top, safe: true)
            sideSymetric(view: view, padding: 0, safe: true)
            getConst(view: view, side: .bottom, safe: true)
        case .noneTopPadding:
            getConst(view: view, side: .top, padding: padding)
            sideSymetric(view: view, padding: height)
            getConst(view: view, side: .bottom, padding: -height)
        case .modalLeft:
            getConst(view: secondView, side: .top, padding: -20)
            getConst(view: view, side: .left, padding: 0)
            getConst(view: view, side: .height, padding: height)
            getConst(view: view, side: .width, padding: padding)
            //trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .modalRight:
            getConst(view: secondView, side: .top, padding: -20)
            getConst(view: secondView, side: .right, padding: 10)
            getConst(view: view, side: .height, padding: height)
            getConst(view: view, side: .width, padding: padding)
        case .modal:
            getConst(view: view, side: .left, padding: 5)
            getConst(view: view, side: .centerY)
        case .padding:
            sideCenter(view: view)
            getConst(view: view, side: .left, padding: 10, typeEqual: .greater)
            getConst(view: view, side: .right, padding: -10, typeEqual: .less)
            if width > 0 {
                getConst(view: view, side: .width, padding: width)
            }
        case .paddingTop:
            getConst(view: view, side: .top, padding: 40)
            getConst(view: view, side: .left, padding: 10)
            getConst(view: view, side: .right, padding: -10)
            getConst(view: view, side: .bottom)
        case .paddingTopLeft:
            getConst(view: view, side: .top, padding: 25)
            getConst(view: view, side: .left, padding: 10)
            getConst(view: view, side: .right, padding: -10, typeEqual: .less)
            getConst(view: view, side: .bottom)
        case .paddingTopRight:
            getConst(view: view, side: .top, padding: 16)
            getConst(view: view, side: .left, padding: 58, typeEqual: .greater)
            getConst(view: view, side: .right, padding: -10)
            getConst(view: view, side: .bottom)
        case .secondTop:
            getConst(view: view, side: .top, padding: padding)
            getConst(view: view, side: .height, padding: height)
            getConst(view: view, side: .width, padding: width)
            getConst(view: view, side: .centerX)
        case .fullState:
            getConst(view: secondView, side: .topBottom)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .bottom)
        case .fullStatePadding:
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .bottom)
        case .fullStatePaddingAll:
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .bottom, padding: finalPadding.bottom)
        case .full:
            getConst(view: view, side: .top)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: bottomView, side: .bottomTop)
        case .fullStack:
            sideSymetric(view: view, padding: finalPadding.top, vertical: true)
            sideSymetric(view: view, padding: finalPadding.left)
            //getConst(view: view, side: .width, padding: view.widthAnchor)
            widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            getConst(view: view, side: .height, padding: height)
        case .fullPadding:
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: secondView, side: .topBottom)
            getConst(view: bottomView, side: .bottomTop)
        case .fullLimit:
            getConst(view: secondView, side: .topBottom)
            getConst(view: bottomView, side: .bottomTop)
            getConst(view: view, side: .left, typeEqual: .greater)
            getConst(view: view, side: .right, typeEqual: .less)
        case .fullBottom:
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top)
            getConst(view: view, side: .bottom, padding: finalPadding.bottom)
            getConst(view: view, side: .left, padding: 20, typeEqual: .greater)
            getConst(view: view, side: .right, padding: 20, typeEqual: .less)
            getConst(view: view, side: .centerX)
            getConst(view: view, side: .width, padding: width)
        case .fullBottomCenter:
            getConst(view: secondView, side: .topBottom, padding: 10)
            getConst(view: view, side: .bottom, padding: -20)
            getConst(view: view, side: .height, padding: height)
            getConst(view: view, side: .centerX)
        case .topHeightFixPadding:
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top)
            sideSymetric(view: view, padding: 8)
            getConst(view: view, side: .height, padding: height)
        case .bottomHeightFixPadding:
            getConst(view: secondView, side: .bottomTop, padding: finalPadding.bottom)
            sideSymetric(view: view, padding: 8)
            getConst(view: view, side: .height, padding: height)
        case .topHeightPadding:
            getConst(view: secondView, side: .topBottom, padding: finalPadding.top / 2)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: height)
        case .fullWidth:
            getConst(view: secondView, side: .leftRight)
            getConst(view: bottomView, side: .rightLeft)
            getConst(view: view, side: .bottom)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .leftBottom:
            getConst(view: view, side: .left)
            getConst(view: view, side: .bottom)
            sizeSymetric(view: view, size: height)
        case .leftCenterY:
            getConst(view: view, side: .left, padding: -finalPadding.left)
            getConst(view: view, side: .centerY)
            getConst(view: view, side: .height, padding: finalPadding.height)
            getConst(view: secondView, side: .rightLeft, padding: finalPadding.left)
        case .rightCenterY:
            getConst(view: view, side: .right, padding: -finalPadding.right)
            sizeSymetric(view: view, size: height)
            getConst(view: view, side: .centerY)
        case .rightBottom:
            getConst(view: view, side: .right, padding: finalPadding.right)
            getConst(view: view, side: .bottom)
            sizeSymetric(view: view, size: height)
        case .rightTop:
            getConst(view: view, side: .right, padding: finalPadding.right)
            getConst(view: view, side: .top, padding: finalPadding.top)
            sizeSymetric(view: view, size: height)
        case .center:
            sideCenter(view: view)
        case .centerSize:
            sideCenter(view: view)
            getConst(view: view, side: .height, padding: finalPadding.height)
            getConst(view: view, side: .width, padding: finalPadding.left)
        case .centerSizeUp:
            getConst(view: view, side: .top, safe: true)
            getConst(view: view, side: .centerX)
            getConst(view: view, side: .height, padding: finalPadding.height)
            getConst(view: view, side: .width, padding: finalPadding.left)
        case .leftAdjust:
            getConst(view: view, side: .centerY)
            getConst(view: secondView, side: .rightLeft, padding: -8)
            sizeSymetric(view: view, size: finalPadding.height)
        case .rightMiddle:
            getConst(view: view, side: .centerY)
            getConst(view: view, side: .right)
            sizeSymetric(view: view, size: 50)
        case .leftMiddle:
            getConst(view: view, side: .centerY)
            sizeSymetric(view: view, size: 50)
            getConst(view: view, side: .left)
        case .topMiddle:
            getConst(view: view, side: .centerX)
            getConst(view: view, side: .top, safe: true)
            sizeSymetric(view: view, size: 50)
        case .bottomMiddle:
            getConst(view: view, side: .centerX)
            getConst(view: view, side: .bottom)
            sizeSymetric(view: view, size: 50)
        case .fullStackH:
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .fullStackV:
            sideSymetric(view: view, padding: finalPadding.top, vertical: true)
            getConst(view: view, side: .height, padding: finalPadding.height)
            getConst(view: view, side: .centerY)
        case .dropDown:
            getConst(view: view, side: .topBottom, padding: finalPadding.bottom)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .dropDownUp:
            getConst(view: view, side: .bottomTop, padding: finalPadding.top)
            sideSymetric(view: view, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .dropDownTop:
            getConst(view: secondView, side: .topBottom, padding: 1)
            sideSymetric(view: secondView, padding: finalPadding.left)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .dropDownTopHeight:
            getConst(view: secondView, side: .topBottom, padding: 1)
            getConst(view: secondView, side: .right, padding: finalPadding.right)
            getConst(view: view, side: .width, padding: 250)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .dropDownTopHeightLeft:
            getConst(view: secondView, side: .topBottom, padding: 1)
            getConst(view: secondView, side: .left, padding: -finalPadding.left)
            getConst(view: view, side: .width, padding: 250)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .dropDownBottomHeight:
            getConst(view: secondView, side: .bottomTop, padding: 1)
            getConst(view: secondView, side: .left, padding: -finalPadding.left)
            getConst(view: view, side: .width, padding: 250)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .dropDownBottomHeightLeft:
            getConst(view: secondView, side: .bottomTop, padding: 1)
            getConst(view: secondView, side: .right, padding: finalPadding.right)
            getConst(view: view, side: .width, padding: 250)
            getConst(view: view, side: .height, padding: finalPadding.height)
        case .bottomRight:
            sizeSymetric(view: view, size: height)
            getConst(view: view, side: .right, padding: secondPadding)
            getConst(view: view, side: .bottom, padding: finalPadding.bottom)
        case .alignViewLeft:
            centerYAnchor.constraint(equalTo: secondView.centerYAnchor).isActive = true
            getConst(view: view, side: .right, padding: 0)
            sizeSymetric(view: view, size: finalPadding.height)
        }
        return self
    }
    private func getConst(view: UIView, side: sideConst, padding: CGFloat = 0, safe: Bool = false, typeEqual: sideType = .equal ) {
        //var finalView: UIView = safe ? view.safeAreaLayoutGuide : view
        switch side {
        
        case .top:
            let finalCt = safe ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
            let finalAxis = axisConst(mainY: topAnchor, secondY: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
            /*topAnchor.constraint(
                equalTo: safe ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor,
                constant: padding ).isActive = true*/
        case .bottom:
            let finalCt = safe ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
            let finalAxis = axisConst(mainY: bottomAnchor, secondY: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
        case .left:
            let finalCt = safe ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
            let finalAxis = axisConst(mainX: leadingAnchor, secondX: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
        case .right:
            let finalCt = safe ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
            let finalAxis = axisConst(mainX: trailingAnchor, secondX: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
        case .topBottom:
            let finalCt = safe ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
            let finalAxis = axisConst(mainY: topAnchor, secondY: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
        case .bottomTop:
            let finalCt = safe ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
            let finalAxis = axisConst(mainY: bottomAnchor, secondY: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
        case .rightLeft:
            let finalCt = safe ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
            let finalAxis = axisConst(mainX: trailingAnchor, secondX: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
        case .leftRight:
            let finalCt = safe ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
            let finalAxis = axisConst(mainX: leadingAnchor, secondX: finalCt)
            getFinalConst(axis: finalAxis, padding: padding, typeEqual: typeEqual)
        case .centerX:
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: padding).isActive = true
        case .centerY:
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: padding).isActive = true
        case .width:
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .height:
            heightAnchor.constraint(equalToConstant: padding).isActive = true
        case .heightMultiplier:
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: padding).isActive = true
        }
    }
    private func getFinalConst(axis: axisConst, padding: CGFloat, typeEqual: sideType = .equal) {
        if let mainAxis = axis.mainX, let secondAxis = axis.secondX {
            switch typeEqual {
            case .equal:
                mainAxis.constraint(
                    equalTo: secondAxis,
                    constant: padding ).isActive = true
            case .greater:
                mainAxis.constraint(
                    greaterThanOrEqualTo: secondAxis,
                    constant: padding ).isActive = true
            case .less:
                mainAxis.constraint(
                    lessThanOrEqualTo: secondAxis,
                    constant: padding ).isActive = true
                
            }
        }
        if let mainAxis = axis.mainY, let secondAxis = axis.secondY {
            switch typeEqual {
            case .equal:
                mainAxis.constraint(
                    equalTo: secondAxis,
                    constant: padding ).isActive = true
            case .greater:
                mainAxis.constraint(
                    greaterThanOrEqualTo: secondAxis,
                    constant: padding ).isActive = true
            case .less:
                mainAxis.constraint(
                    lessThanOrEqualTo: secondAxis,
                    constant: padding ).isActive = true
                
            }
        }
        
    }
    
    private func sideSymetric(view: UIView, padding: CGFloat, vertical: Bool = false, safe: Bool = false){
        if vertical {
            getConst(view: view, side: .top, padding: padding, safe: safe)
            getConst(view: view, side: .bottom, padding: -padding, safe: safe)
        } else {
            getConst(view: view, side: .left, padding: padding, safe: safe)
            getConst(view: view, side: .right, padding: -padding, safe: safe)
        }
    }
    private func sideCenter(view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    private func sizeSymetric(view: UIView, size: CGFloat){
        getConst(view: view, side: .height, padding: size)
        getConst(view: view, side: .width, padding: size)
    }
}
private struct paddingConst {
    var top: CGFloat
    var bottom: CGFloat
    var left: CGFloat
    var right: CGFloat
    var centerX: CGFloat
    var centerY: CGFloat
    var height: CGFloat
    var width: CGFloat
    init(
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        left: CGFloat = 0,
        right: CGFloat = 0,
        centerX: CGFloat = 0,
        centerY: CGFloat = 0,
        height: CGFloat = 0,
        width: CGFloat = 0
    ) {
        
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
        self.centerX = centerX
        self.centerY = centerY
        self.height = height
        self.width = width
    }
}
private struct axisConst {
    var mainY: NSLayoutYAxisAnchor?
    var secondY: NSLayoutYAxisAnchor?
    var mainX: NSLayoutXAxisAnchor?
    var secondX: NSLayoutXAxisAnchor?
    init(
        mainY: NSLayoutYAxisAnchor? = nil,
        secondY: NSLayoutYAxisAnchor? = nil,
        mainX: NSLayoutXAxisAnchor? = nil,
        secondX: NSLayoutXAxisAnchor? = nil
    ) {
        self.mainY = mainY
        self.secondY = secondY
        self.mainX = mainX
        self.secondX = secondX
    }
}

