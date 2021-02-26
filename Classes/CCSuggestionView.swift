//
//  SuggestionView.swift
//  chata
//
//  Created by Vicente Rincon on 16/03/20.
//

import Foundation
import UIKit
protocol SuggestionViewDelegate: class {
    func selectSuggest(query: String)
}
class SuggestionView: UIView {
    let label = UILabel()
    let vwOptions = UIView()
    let stack = UIStackView()
    let scrollView = UIScrollView()
    weak var delegate: ChatViewDelegate?
    weak var delegateSuggestion: SuggestionViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadConfig(options: [String], query: String, first: Bool = true) {
        /*label.text = "I want to make sure I understood your query. Did you mean:"
        label.numberOfLines = 0
        label.setSize()
        label.textColor = chataDrawerTextColorPrimary*/
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.distribution  = UIStackView.Distribution.fillEqually
        stack.alignment = UIStackView.Alignment.center
        stack.spacing = 8
        /*self.addSubview(label)
        label.edgeTo(self, safeArea: .topView, height: 50, padding: 8)*/
        self.addSubview(scrollView)
        scrollView.edgeTo(self, safeArea: .noneTopPadding, padding: 16)
        scrollView.addSubview(stack)
        let finalHeight = CGFloat(options.count * 40)
        stack.edgeTo(scrollView, safeArea: .fullStack, height: finalHeight)
        /*scrollView.addSubview(stack)
        stack.edgeTo(self, safeArea: .fullStatePadding, height: 0, label, padding: 8)*/
        
        loadSuggestion(options: options)
        
    }
    private func loadSuggestion(options: [String]){
        options.forEach { (text) in
            let btn = UIButton()
            btn.setTitle(text, for: .normal)
            btn.setTitleColor(chataDrawerTextColorPrimary, for: .normal)
            btn.cardView()
            stack.addArrangedSubview(btn)
            btn.titleLabel?.font = generalFont
            btn.addTarget(self, action: #selector(selectSuggest), for: .touchUpInside)
            btn.edgeTo(stack, safeArea: .fullStackH, height: 50, padding: 8)
        }
    }
    @IBAction func selectSuggest(_ sender: AnyObject){
        if let buttonTitle = sender.title(for: .normal) {
            delegateSuggestion?.selectSuggest(query: buttonTitle)
            let typingSend = TypingSend(text: buttonTitle, safe: false)
            NotificationCenter.default.post(name: notifTypingText,
                                            object: typingSend)
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
