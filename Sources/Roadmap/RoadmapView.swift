//
//  RoadmapView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

public struct RoadmapView<Header: View, Footer: View, Loader: View>: View {
    @StateObject var viewModel: RoadmapViewModel
    let header: Header
    let footer: Footer
    let loader: Loader
    
    public var body: some View {
            featuresList
                .scrollContentHidden()
                .listStyle(.plain)
                .conditionalSearchable(if: viewModel.allowSearching, text: $viewModel.searchText)
    }
    
    var featuresList: some View {
        List {
            header
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            
            if viewModel.filteredFeatures.isEmpty {
                loader
            } else {
                ForEach(viewModel.filteredFeatures) { feature in
                    RoadmapFeatureView(viewModel: viewModel.featureViewModel(for: feature))
                        .macOSListRowSeparatorHidden()
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            footer
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
    }
}

public extension RoadmapView where Header == EmptyView, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, @ViewBuilder loader: () -> Loader) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: EmptyView(), loader: loader())
    }
}

public extension RoadmapView where Header: View, Footer == EmptyView {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder loader: () -> Loader) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: EmptyView(), loader: loader())
    }
}

public extension RoadmapView where Header == EmptyView, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder footer: () -> Footer, @ViewBuilder loader: () -> Loader) {
        self.init(viewModel: .init(configuration: configuration), header: EmptyView(), footer: footer(), loader: loader())
    }
}

public extension RoadmapView where Header: View, Footer: View {
    init(configuration: RoadmapConfiguration, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer, @ViewBuilder loader: () -> Loader) {
        self.init(viewModel: .init(configuration: configuration), header: header(), footer: footer(), loader: loader())
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(configuration: .sampleURL()) {
            EmptyView()
        }
    }
}
