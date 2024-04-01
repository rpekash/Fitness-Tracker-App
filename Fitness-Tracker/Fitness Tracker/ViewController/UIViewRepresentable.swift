////
////  UIViewRepresentable.swift
////  Fitness Tracker
////
////  Created by Kastrijot Syla on 3/18/24.
////
//
//import SwiftUI
//import Charts // Ensure this is correctly imported
//
//struct LineChartUIView: UIViewRepresentable {
//    var entries: [ChartDataEntry]
//
//    func makeUIView(context: Context) -> LineChartView {
//        let chartView = LineChartView()
//        // Configure initial chart view properties here if needed
//        return chartView
//    }
//
//    func updateUIView(_ uiView: LineChartView, context: Context) {
//        let dataSet = LineChartDataSet(entries: entries, label: "Weight")
//        dataSet.colors = [NSUIColor.red]
//        dataSet.valueColors = [NSUIColor.black]
//
//        uiView.data = LineChartData(dataSets: [dataSet])
//        // Further customization of the chart view
//    }
//}
//
