//
//  BodyWeightView.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 2/21/24.
//


import UIKit
import SwiftUI
import SnapKit



class BodyWeightView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        let controller = UIHostingController(rootView: BodyWeightHistory())
        guard let bodyweightView = controller.view else{
            return
        }
        
        view.addSubview(bodyweightView)
        
        bodyweightView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(400)
        }
                                        
    }
}
