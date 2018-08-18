//
//  Common.swift
//  TrustOr
//
//  Created by Dmitry Dementyev on 16.08.2018.
//  Copyright © 2018 Dmitry Dementyev. All rights reserved.
//

import UIKit

func makeRoundedColorButton(for button: UIButton) {
    button.backgroundColor = K.foregroundColor
    button.setTitleColor(K.backgroundColor, for: .normal)
    button.layer.cornerRadius = 0.5 * button.bounds.size.height
}

func makeRoundedGrayButton(for button: UIButton) {
    button.backgroundColor = K.grayColor
    button.setTitleColor(K.backgroundColor, for: .normal)
    button.layer.cornerRadius = 0.5 * button.bounds.size.height
}