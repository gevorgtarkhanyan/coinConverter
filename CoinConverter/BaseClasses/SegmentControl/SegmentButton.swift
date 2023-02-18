//
//  SegmentButton.swift
//  MinerBox
//
//  Created by Ruben Nahatakyan on 7/19/19.
//  Copyright © 2019 WitPlex. All rights reserved.
//

import UIKit

class SegmentButton: BaseButton {
    override func changeColors() {
        setTitleColor(darkMode ? .white : UIColor.black.withAlphaComponent(0.85), for: .normal)
    }
}
