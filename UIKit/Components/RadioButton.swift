//
//  RadioButton.swift
//  Blu
//
//  Created by Victor C Tavernari on 30/06/20.
//  Copyright © 2020 Blu. All rights reserved.
//

import UIKit
import OceanTokens

public class RadioButton: UIControl, Renderable {

    var mainStack: UIStackView!
    private var radioBkgView: UIControl!
    private var textLabel: UILabel!

    public var label: String = ""{
        didSet {
            textLabel?.text = label
        }
    }

    public var onTouch: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeView()
    }

    convenience init(builder: ((RadioButton) -> Void)? = nil) {
        self.init(frame: .zero)
        builder?(self)
    }

    public override var isSelected: Bool {
        didSet {
            updateState()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateState()
        }
    }

    public override var isUserInteractionEnabled: Bool {
        didSet {
            updateState()
        }
    }

    private var backgroundCircleLayer: CAShapeLayer!
    private var foregroundCircleLayer: CAShapeLayer!

    private var size: CGFloat = 24

    private lazy var backgroundPath: CGPath = {
        return UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size)).cgPath
    }()

    private lazy var foregroundShrinkPath: CGPath = {
        let circleSize = size*0.3
        let center = size*0.5-circleSize*0.5
        return UIBezierPath(ovalIn: CGRect(x: center, y: center, width: circleSize, height: circleSize)).cgPath
    }()

    private lazy var foregroundExpandPath: CGPath = {
        let circleSize = size*0.8
        let center = size*0.5-circleSize*0.5
        return UIBezierPath(ovalIn: CGRect(x: center, y: center, width: circleSize, height: circleSize)).cgPath
    }()

    @objc private func toogleRadio() {
        onTouch?()
        isSelected = !isSelected
    }

    private func updateState() {
        if isSelected {
            changeToChecked()
        } else {
            changeToUnchecked()
        }
    }

    func makeView() {
        mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.alignment = .leading
        mainStack.distribution = .fill

        let radioStack = UIStackView()
        radioStack.translatesAutoresizingMaskIntoConstraints = false
        radioStack.axis = .horizontal
        radioStack.alignment = .leading
        radioStack.distribution = .fill

        mainStack.addArrangedSubview(radioStack)

        radioBkgView = UIControl()
        radioBkgView.translatesAutoresizingMaskIntoConstraints = false

        if backgroundColor == nil || backgroundColor == UIColor.clear {
            backgroundColor = Ocean.color.colorInterfaceLightPure
        }

        radioBkgView.addTarget(self, action: #selector(toogleRadio), for: .touchUpInside)

        radioBkgView.heightAnchor.constraint(equalToConstant: size).isActive = true
        radioBkgView.widthAnchor.constraint(equalToConstant: size).isActive = true

        backgroundCircleLayer = CAShapeLayer()
        backgroundCircleLayer.path = backgroundPath
        backgroundCircleLayer.fillColor = Ocean.color.colorHighlightPure.cgColor

        foregroundCircleLayer = CAShapeLayer()
        foregroundCircleLayer.path = foregroundShrinkPath
        foregroundCircleLayer.fillColor = Ocean.color.colorInterfaceLightPure.cgColor

        radioBkgView.layer.addSublayer(backgroundCircleLayer)
        radioBkgView.layer.addSublayer(foregroundCircleLayer)

        textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: Ocean.font.fontFamilyBaseWeightRegular, size: Ocean.font.fontSizeXs)
        textLabel.text = label

        radioStack.addArrangedSubview(radioBkgView)
        radioStack.addArrangedSubview(Spacer(space: Ocean.size.spacingInlineXxs))
        radioStack.addArrangedSubview(textLabel)
        self.addSubview(mainStack)

        mainStack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainStack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.updateState()
    }

    private func updateLabelColor() {
        textLabel.textColor = isEnabled ? Ocean.color.colorInterfaceDarkDown : Ocean.color.colorInterfaceLightDeep
    }

    private func changeToChecked() {
        changeForegroundCircle(path: foregroundShrinkPath)
        let color = isEnabled ? Ocean.color.colorHighlightPure : Ocean.color.colorInterfaceDarkUp
        changeShapeColorOf(layer: backgroundCircleLayer, color: color)
        updateLabelColor()
    }

    private func changeToUnchecked() {
        changeForegroundCircle(path: foregroundExpandPath)
        let backgroundCircleColor = isEnabled ? Ocean.color.colorInterfaceDarkUp : Ocean.color.colorInterfaceLightDeep
        changeShapeColorOf(layer: backgroundCircleLayer, color: backgroundCircleColor)

        if let foregroundCircleColor = isEnabled ? Ocean.color.colorInterfaceLightPure : backgroundColor {
            changeShapeColorOf(layer: foregroundCircleLayer, color: foregroundCircleColor)
        }

        updateLabelColor()
    }

    private func changeForegroundCircle(path: CGPath) {
        guard path != foregroundCircleLayer.path else {
            return
        }

        let key = "foregroundRadioPath"
        layer.removeAnimation(forKey: key)

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.3
        animation.fromValue = foregroundCircleLayer.path
        animation.toValue = path
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        foregroundCircleLayer.path = path
        foregroundCircleLayer.add(animation, forKey: key)
    }

    private func changeShapeColorOf(layer: CAShapeLayer, color: UIColor) {
        guard layer.fillColor != color.cgColor else {
            return
        }

        let key = "backgroundRadioColor"
        layer.removeAnimation(forKey: key)

        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.duration = 0.6
        animation.fromValue = layer.fillColor
        animation.toValue = color.cgColor
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layer.fillColor = color.cgColor
        layer.add(animation, forKey: key)
    }
}
