//
//  ModulesView.swift
//  ModulesGPT
//
//  Created by Giorgio Ferraz on 2/8/23.
//

import SwiftUI

struct ModulesView: View {
    @EnvironmentObject private var model: AppModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List(Modules.allCases) { module in
                    Button {
                        model.selectedModule = module
                    } label: {
                        Label {
                            Text(module.title)
                                .font(.system(size: 20, weight: .medium))
                                .padding(.vertical, 10)
                        } icon: {
                            Image(systemName: module.sfSymbol)
                        }
                    }
                }
            }
            .navigationTitle("Modules")
            .sheet(item: $model.selectedModule) { screen in
                switch screen {
                case .newChat: NewChatView()
                case .randomConcept: ConceptView()
                case .relatedTopics: RelatedTopicsView()
                case .definition: DefinitionView()
                case .article: ArticleView()
                case .expanded: ExpandedView()
                case .summarized: SummarizedView()
                case .comparison: ComparisonView()
                case .next: NextView()
                case .affirmation: AffirmationView()
                }
            }
        }
    }
}

