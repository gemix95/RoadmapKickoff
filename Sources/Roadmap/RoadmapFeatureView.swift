//
//  RoadmapFeatureView.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import SwiftUI

struct RoadmapFeatureView: View {
    @Environment(\.dynamicTypeSize) var typeSize
    @StateObject var viewModel: RoadmapFeatureViewModel

    var body: some View {
        ZStack{
            if typeSize.isAccessibilitySize {
                verticalCell
            } else {
                horizontalCell
            }
        }
        .background(viewModel.configuration.style.cellColor)
        .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
        .task {
            await viewModel.getCurrentVotes()
        }
        
    }
    
    var horizontalCell : some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.feature.localizedFeatureTitle)
                    .font(viewModel.configuration.style.titleFont)
                
                let description = viewModel.feature.localizedFeatureDescription
                if !description.isEmpty {
                    Text(description)
                        .font(viewModel.configuration.style.descriptionFont)
                        .foregroundColor(Color.secondary)
                }

                if let localizedStatus = viewModel.feature.localizedFeatureStatus {
                    let status = viewModel.feature.unlocalizedFeatureStatus
                    Text(localizedStatus)
                        .padding(6)
                        .background(makeBackgroundStatusColor(with: status))
                        .foregroundColor(makeForegroundStatusColor(with: status))
                        .cornerRadius(5)
                        .font(viewModel.configuration.style.statusFont)
                }
            }
            
            Spacer()
            
            if viewModel.feature.hasNotFinished {
                RoadmapVoteButton(viewModel: viewModel)
            }
        }
        .padding()
    }
    
    var verticalCell : some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.feature.hasNotFinished {
                HStack {
                    RoadmapVoteButton(viewModel: viewModel)
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(viewModel.feature.localizedFeatureTitle)
                        .font(viewModel.configuration.style.titleFont)
                    
                    if !viewModel.feature.hasNotFinished {
                        Spacer()
                    }
                }
                
                let description = viewModel.feature.localizedFeatureDescription
                if !description.isEmpty {
                    Text(description)
                        .font(viewModel.configuration.style.numberFont)
                        .foregroundColor(Color.secondary)
                }

                if let localizedStatus = viewModel.feature.localizedFeatureStatus {
                    let status = viewModel.feature.unlocalizedFeatureStatus
                    Text(localizedStatus)
                        .padding(6)
                        .background(makeBackgroundStatusColor(with: status))
                        .foregroundColor(makeForegroundStatusColor(with: status))
                        .cornerRadius(5)
                        .font(viewModel.configuration.style.statusFont)
                }
            }
        }
        .padding()
    }
    
    func makeBackgroundStatusColor(with status: String) -> Color {
        switch status.lowercased() {
        case "work in progress":
            return Color(red: 10/255, green: 255/255, blue: 175/255)
        case "backlog":
            return Color(red: 35/255, green: 97/255, blue: 90/255)
        case "released":
            return Color(red: 8/255, green: 21/255, blue: 19/255)
        default:
            return Color.primary
        }
    }
    
    func makeForegroundStatusColor(with status: String) -> Color {
        switch status.lowercased() {
        case "work in progress":
            return Color(red: 20/255, green: 28/255, blue: 33/255)
        case "backlog":
            return Color(red: 19/255, green: 255/255, blue: 172/255)
        case "released":
            return Color(red: 35/255, green: 97/255, blue: 90/255)
        default:
            return Color.secondary
        }
    }
}

struct RoadmapFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapFeatureView(viewModel: .init(feature: .sample(), configuration: .sampleURL()))
    }
}
