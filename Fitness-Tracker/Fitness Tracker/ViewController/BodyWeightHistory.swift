//
//  BodyWeightHistory.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 3/17/24.
//

import SwiftUI
import Charts
import Foundation

struct WeightModel: Identifiable  {
    let id = UUID()
    let amount: Double
    let createAt: Date
}

struct BodyWeightHistory: View {
        let list = [
            WeightModel(amount: 200, createAt: dateFormatter.date(from: "5/12/2023") ?? Date()),
            WeightModel(amount: 210, createAt: dateFormatter.date(from: "5/15/2023") ?? Date()),
            WeightModel(amount: 200, createAt: dateFormatter.date(from: "5/18/2023") ?? Date()),
            WeightModel(amount: 225, createAt: dateFormatter.date(from: "5/23/2023") ?? Date()),
            WeightModel(amount: 210, createAt: dateFormatter.date(from: "5/24/2023") ?? Date()),
            WeightModel(amount: 208, createAt: dateFormatter.date(from: "5/28/2023") ?? Date()),
            WeightModel(amount: 230, createAt: dateFormatter.date(from: "6/1/2023") ?? Date()),

        ]
    
    func formatDate(_ date: Date) -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.day, .month], from: date)
        guard let day = dateComponents.day, let month = dateComponents.month else {
            return "-"
        }
        return "\(day)/\(month)"
        
    }
        
        static var dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yy"
            return df
        }()
        
        var body: some View {
            Chart(list){ weightModel in
                LineMark(
                    x: .value("Month", formatDate(weightModel.createAt)),
                    y: .value("Weight", weightModel.amount)
                ).foregroundStyle(.red)
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(.red)
                
                PointMark(
                    x: .value("Month", formatDate(weightModel.createAt)),
                    y: .value("Weight", weightModel.amount)
                ).foregroundStyle(.black)
                
                
            }.chartYAxis {
                AxisMarks(position: . leading)
            }
        }
    }

