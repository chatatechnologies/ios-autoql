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
    private func loadConfig() {
        self.backgroundColor = chataDrawerAccentColor
        let cancel = UIButton()
        cancel.setTitleColor(.white, for: .normal)
        let image = UIImage(named: "icCancel.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        cancel.setImage(image, for: .normal)
        self.addSubview(cancel)
        cancel.edgeTo(self, safeArea: .leftBottom, height: 40.0, self)
        cancel.padding(7)
        cancel.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let delete = UIButton()
        let image2 = UIImage(named: "icDelete.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        delete.setImage(image2, for: .normal)
        delete.setTitleColor(.white, for: .normal)
        delete.padding()
        delete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        self.addSubview(delete)
        delete.edgeTo(self, safeArea: .rightBottom, height: 40.0, self)
        let label = UILabel()
        label.text = DataConfig.title
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        self.addSubview(label)
        label.edgeTo(self, safeArea: .fullWidth, height: 40.0, cancel, delete)
    }
    @objc func buttonAction(sender: UIButton!) {
        if let father = self.superview as? Chat {
            father.dismiss(animated: DataConfig.clearOnClose)
        }
    }
    @objc func deleteAction(sender: UIButton!) {
        delegate?.delete()
    }
}
