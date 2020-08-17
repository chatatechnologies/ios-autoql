//
//  SuggestionView.swift
//  chata
//
//  Created by Vicente Rincon on 16/03/20.
//

import Foundation
import UIKit
class SuggestionView: UIView {
    let label = UILabel()
    let stack = UIStackView()
    weak var delegate: ChatViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadConfig(options: [String], query: String) {
        label.text = "I want to make sure I understood your query. Did you mean:"
        label.numberOfLines = 0
        label.setSize()
        label.textColor = chataDrawerTextColorPrimary
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.distribution  = UIStackView.Distribution.fillEqually
        stack.alignment = UIStackView.Alignment.center
        stack.spacing = 8
        self.addSubview(label)
        label.edgeTo(self, safeArea: .topPadding, height: 50, padding: 8)
        self.addSubview(stack)
        stack.edgeTo(self, safeArea: .fullStatePadding, height: 0, label, padding: 8)
        loadSuggestion(options: options)
        //guard let confettiImageView = UIImageView.fromGif(frame: self.frame, resourceName: "preloader.gif") else { return }
        //self.addSubview(confettiImageView)
        //confettiImageView.edgeTo(self, safeArea: .none)
        //confettiImageView.startAnimating()
        
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
            btn.edgeTo(stack, safeArea: .fullStackH, height: 0, padding: 8)
        }
    }
    @IBAction func selectSuggest(_ sender: AnyObject){
        if let buttonTitle = sender.title(for: .normal) {
            delegate?.sendText(buttonTitle, true)
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
