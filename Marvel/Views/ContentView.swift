//
//  ContentView.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

            VStack {
                TextField(viewModel.searchPlaceholder, text: $viewModel.query)

                List {
                    ForEach(viewModel.rows) { row in
                        Text(row.name)
                    }
                    ActivityIndicatorView(isAnimating: true, style: .medium)
                        .onAppear(perform: viewModel.updateResults)
                }
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
