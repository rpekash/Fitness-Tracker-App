//
//  BodyWeightViewRepresentable.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 3/17/24.
//

import SwiftUI
import UIKit

// UIViewControllerRepresentable wrapper for BodyWeightView
struct BodyWeightViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BodyWeightView {
        BodyWeightView() 
    }
    
    func updateUIViewController(_ uiViewController: BodyWeightView, context: Context) {
    }
}
