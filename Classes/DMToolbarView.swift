//
//  Toolbar.swift
//  chata
//
//  Created by Vicente Rincon on 20/02/20.
//

import Foundation
protocol ToolbarViewDelegate: class {
    func delete()
}
class ToolbarView: UIView {
    var vwMain = UIView()
    let lblTitle = UILabel()
    let btnDelete = UIButton()
    var title = ""
    weak var delegate: ToolbarViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func didMoveToSuperview() {
        loadConfig()
    }
    func reloadData(_ mainTitle: String) {
        lblTitle.text = mainTitle
        btnDelete.isHidden = true
    }
    private func loadConfig() {
        self.backgroundColor = chataDrawerAccentColor
        let cancel = UIButton()
        cancel.setTitleColor(.white, for: .normal)
        let image = UIImage(named: "icCancel.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        cancel.setImage(image, for: .normal)
        self.addSubview(cancel)
        cancel.edgeTo(self, safeArea: .leftBottom, height: 40.0, self)
        cancel.padding(7)
        cancel.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        let image2 = UIImage(named: "icDeleteBar.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        btnDelete.setImage(image2, for: .normal)
        btnDelete.setTitleColor(.white, for: .normal)
        btnDelete.padding()
        btnDelete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        self.addSubview(btnDelete)
        btnDelete.edgeTo(self, safeArea: .rightBottom, height: 40.0, self)
        lblTitle.text = DataConfig.title
        lblTitle.textColor = .white
        lblTitle.textAlignment = .center
        lblTitle.setSize(16, true)
        self.addSubview(lblTitle)
        lblTitle.edgeTo(self, safeArea: .fullWidth, height: 40.0, cancel, btnDelete)
    }
    @objc func actionClose(sender: UIButton!) {
        if let father = self.superview?.superview as? MainChat {
            father.dismiss(animated: DataConfig.clearOnClose)
        }
    }
    func updateTitle(text: String, noDeleteBtn: Bool = false) {
        lblTitle.text = text
        btnDelete.isHidden = noDeleteBtn
    }
    @objc func deleteAction(sender: UIButton!) {
        delegate?.delete()
    }
}
