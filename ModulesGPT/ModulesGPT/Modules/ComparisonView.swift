//
//  ComparisonView.swift
//  ModulesGPT
//
//  Created by Giorgio Ferraz on 2/10/23.
//

import SwiftUI

struct ComparisonView: View {
    @EnvironmentObject private var model: AppModel
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack {
                        HStack {
                            TextField("Required", text: $model.differencesEntryText1, axis: .vertical)
                                .focused($fieldIsFocused)
                                .padding(8)
                                .background(Color(.secondarySystemFill).cornerRadius(10))
                                .padding(.leading, 24)
                            if model.differencesEntryText1.isEmpty {
                                Button("Paste") {
                                    model.differencesEntryText1 = UIPasteboard.general.string ?? ""
                                }
                            }
                        }.padding(.trailing, 24)
                        Text("Provide text")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 34)
                    }
                    
                    VStack {
                        HStack {
                            TextField("Required", text: $model.differencesEntryText2, axis: .vertical)
                                .focused($fieldIsFocused)
                                .padding(8)
                                .background(Color(.secondarySystemFill).cornerRadius(10))
                                .padding(.leading, 24)
                            if model.differencesEntryText2.isEmpty {
                                Button("Paste") {
                                    model.differencesEntryText2 = UIPasteboard.general.string ?? ""
                                }
                            }
                        }.padding(.trailing, 24)
                        Text("Provide text")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 34)
                    }
                    
                    if model.isEmptyComparisonScreen, !model.differencesEntryText1.isEmpty, !model.differencesEntryText2.isEmpty {
                        Text("Tap 'Generate' in the top right corner of your screen")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    if model.isThinking {
                        VStack {
                            Text("Generating comparison...")
                            ProgressView().progressViewStyle(.circular)
                        }
                    }
                    
                    if model.hasResultComparisonScreen {
                        ResultView(generatedText: model.generatedDifferences)
                    }
                    
                }
                .padding(.vertical, 32)
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Comparison")
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
                    if !model.generatedDifferences.isEmpty {
                        Button("Reset") {
                            model.differencesEntryText1 = ""
                            model.differencesEntryText2 = ""
                            model.generatedDifferences = ""
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Generate") {
                    model.makeComparison()
                }.disabled(model.isThinking || model.differencesEntryText1.isEmpty || model.differencesEntryText2.isEmpty)
            }
        }
    }
}
