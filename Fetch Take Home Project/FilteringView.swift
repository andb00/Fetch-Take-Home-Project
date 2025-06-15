//
//  FilteringView.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/14/25.
//

import SwiftUI

struct FilteringView: View {
    @Environment(RecipeViewModel.self) var viewModel
    var body: some View {
        @Bindable var viewModel = viewModel
        List {
            Section(header: Text("Cuisines")) {
                ForEach(0..<viewModel.filterOptions.count, id: \.self) { index in
                    Toggle(viewModel.filterOptions[index], isOn: $viewModel.toggles[index])
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var vm = RecipeViewModel()
    FilteringView()
        .environment(
            {
                vm = RecipeViewModel()
                return vm
            }()
        )
                      
            
}
