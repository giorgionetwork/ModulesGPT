//
//  RelatedTopicsView.swift
//  ModulesGPT
//
//  Created by Giorgio Ferraz on 2/10/23.
//

import SwiftUI

struct RelatedTopicsView: View {
    @EnvironmentObject private var model: AppModel
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack {
                        HStack {
                            TextField("Required", text: $model.relatedTopicsEntryText, axis: .vertical)
                                .focused($fieldIsFocused)
                                .padding(8)
                                .background(Color(.secondarySystemFill).cornerRadius(10))
                                .padding(.leading, 24)
                            if model.relatedTopicsEntryText.isEmpty {
                                Button("Paste") {
                                    model.relatedTopicsEntryText = UIPasteboard.general.string ?? ""
                                }
                            }
                        }.padding(.trailing, 24)
                        Text("Provide text")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 34)
                    }
                    
                    if model.isEmptyRelatedTopicsScreen, !model.relatedTopicsEntryText.isEmpty {
                        Text("Tap 'Generate' in the top right corner of your screen")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    if model.isThinking {
                        VStack {
                            Text("Generating related topics...")
                            ProgressView().progressViewStyle(.circular)
                        }
                    }
                    
                    if model.hasResultRelatedTopicsScreen {
                        ResultView(generatedText: model.generatedRelatedTopics)
                    }
                    
                }
                .padding(.vertical, 32)
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Related Topics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { screenToolbar }
        }
    }
    
    private var screenToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    if !model.generatedRelatedTopics.isEmpty {
                        Button("Reset") {
                            model.relatedTopicsEntryText = ""
                            model.generatedRelatedTopics = ""
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Generate") {
                    model.makeRelatedTopics()
                }.disabled(model.isThinking || model.relatedTopicsEntryText.isEmpty)
            }
        }
    }
}
