//
//  CustomTopBarUIView.swift
//  boiflix
//
//  Created by Duy Ha on 02/01/2024.
//

import UIKit
import SnapKit

protocol CustomTopBarUIViewDelegate: AnyObject {
    func customTopBarUIViewDidTapPopBack()
}

struct TopTitleModel {
    var text: String?
    var font: UIFont? = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    var tintColor: UIColor? = .systemBackground
}

class CustomTopBarUIView: UIView {
    private let backButton: UIButton = {
        let button = UIButton(frame: .init(origin: .zero, size: .init(width: 25.0, height: 25.0)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0, weight: .semibold)), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    weak var delegate: CustomTopBarUIViewDelegate?
    var topTitle = TopTitleModel() {
        didSet { updateUIForTopTitle() }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(backButton)
        addSubview(titleLabel)
        
        applyConstraints()
        
        backButton.addTarget(self, action: #selector(onBackBtnTapped), for: .touchUpInside)
        
        if traitCollection.userInterfaceStyle == .dark {
            backButton.tintColor = .white
        } else {
            backButton.tintColor = .black
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(18.0)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateUIForTopTitle() {
        titleLabel.text = topTitle.text
        titleLabel.font = topTitle.font
        titleLabel.tintColor = topTitle.tintColor
    }
    
    @objc private func onBackBtnTapped() {
        delegate?.customTopBarUIViewDidTapPopBack()
    }

}
