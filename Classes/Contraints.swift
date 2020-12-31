//
//  Countraints.swift
//  chata
//
//  Created by Vicente Rincon on 21/10/20.
//

import Foundation
import UIKit
public enum DViewSafeArea: String, CaseIterable {
    case topView, elementToRight, leading, trailing, bottomView, vertical, horizontal, all, none, noneLeft, widthLeft , widthRight, widthRightY, none2, full, fullStack, fullLimit, fullWidth, leftBottom, rightTop, rightBottom, fullStatePaddingAll, rightCenterY, safe , safeChat, safeChatLeft, safeChatTop, safeChatBottom, safeButtons, safeButtonsLeft, safeButtonsTop, safeButtonsBottom, safeFH, safeFHLeft, safeFHTop, safeFHBottom, leftCenterY, fullState, fullState2, bottomSize, center, leftAdjust, padding, paddingH, paddingTop, rightMiddle = "right", leftMiddle = "left", topMiddle = "top", bottomMiddle = "bottom", fullBottom, fullBottomCenter, paddingTopLeft, paddingTopRight, modal, modal2, modal2Right, dropDownUp, secondTop, bottomPaddingtoTop, bottomPaddingtoTopHalf, fullPadding, topHeight, topHeightPadding, fullStatePaddingTop, dropDownBottomHeight, dropDownBottomHeightLeft,
    topY, nonePadding, fullStackH, topPadding, fullStatePadding, bottomPadding, fullStackV, fullStackHH, dropDown, dropDownTop, dropDownTopView, dropDownTopHeight,dropDownTopHeightLeft, centerSize, bottomRight, centerSizeUp
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
    @discardableResult
    public func edgeTo(_ view: UIView,
                       safeArea: DViewSafeArea = .none,
                       height: CGFloat = 0,
                       width: CGFloat = 0,
                       _ top: UIView = UIView(),
                       _ bottom: UIView = UIView(),
                       padding: CGFloat = -8) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        
        switch safeArea {
        case .topView:
            topConst(view: view.topAnchor)
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .topPadding:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .elementToRight:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .bottomPaddingtoTop:
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
        case .bottomPaddingtoTopHalf:
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.38).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
        case .bottomPadding:
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .bottomRight:
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .leading:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .trailing:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .bottomView:
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .bottomSize:
            bottomAnchor.constraint(equalTo: top.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .vertical:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .horizontal:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .all:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .none:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .noneLeft:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .widthLeft:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .widthRight:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .widthRightY:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        case .safe:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeButtons:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: 1).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .safeButtonsLeft:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            leadingAnchor.constraint(equalTo: top.trailingAnchor, constant: -1).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .safeButtonsTop:
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            topAnchor.constraint(equalTo: top.safeAreaLayoutGuide.bottomAnchor, constant: -1).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .safeButtonsBottom:
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 1).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .safeFH:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeFHLeft:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeFHTop:
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .safeFHBottom:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: top.topAnchor).isActive = true
        case .safeChat:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeChatLeft:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeChatTop:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
        case .safeChatBottom:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .nonePadding:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: height).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -height).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -height).isActive = true
        case .none2:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .modal2:
            topAnchor.constraint(equalTo: top.topAnchor, constant: -20).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
            //trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .modal2Right:
            topAnchor.constraint(equalTo: top.topAnchor, constant: -20).isActive = true
            rightAnchor.constraint(equalTo: top.rightAnchor, constant: 5).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .modal:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .padding:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
            if width > 0 {
                widthAnchor.constraint(equalToConstant: width).isActive = true
            }
        case .paddingH:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .paddingTop:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .paddingTopLeft:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .paddingTopRight:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
            leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 58).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .secondTop:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height * 4).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .fullState:
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .fullStatePadding:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        case .fullStatePaddingAll:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        case .fullStatePaddingTop:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .fullState2:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        case .full:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
        case .fullStack:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullPadding:
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
        case .fullLimit:
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
        case .fullBottom:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20).isActive = true
            trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: width).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .fullBottomCenter:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .topY:
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .topHeight:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .topHeightPadding:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding / 2).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullWidth:
            leadingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: bottom.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .leftBottom:
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .leftCenterY:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -padding).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            heightAnchor.constraint(equalTo: top.heightAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: padding).isActive = true
        case .rightCenterY:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .rightBottom:
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .rightTop:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .center:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .centerSize:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .centerSizeUp:
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -130).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .leftAdjust:
            centerYAnchor.constraint(equalTo: top.centerYAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: -8).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .rightMiddle:
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        case .leftMiddle:
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
            self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        case .topMiddle:
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        case .bottomMiddle:
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        case .fullStackH:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullStackHH:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullStackV:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .dropDown:
            topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownUp:
            bottomAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTop:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTopView:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTopHeight:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTopHeightLeft:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownBottomHeight:
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownBottomHeightLeft:
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 1).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return self
    }
    private func topConst(view: NSLayoutYAxisAnchor){
        topAnchor.constraint(equalTo: view).isActive = true
    }
}

