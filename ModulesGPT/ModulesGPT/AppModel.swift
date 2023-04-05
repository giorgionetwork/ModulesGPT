//
//  AppModel.swift
//  ModulesGPT
//
//  Created by Giorgio Ferraz on 2/8/23.
//

import SwiftUI
import OpenAISwift

final class AppModel: ObservableObject {
    
    @Published var displayModeString: String = "Dark"
    
    @Published var isThinking: Bool = false
    @Published var selectedModule: Modules?
    
    @Published var newChatEntryText: String = ""
    @Published var generatedNewChat: String = ""
    var isEmptyNewChatScreen: Bool { !isThinking && generatedNewChat.isEmpty }
    var hasResultNewChatScreen: Bool { !isThinking && !generatedNewChat.isEmpty }
    
    @Published var generatedConcept: String = ""
    var isEmptyConceptScreen: Bool { !isThinking && generatedConcept.isEmpty }
    var hasResultConceptScreen: Bool { !isThinking && !generatedConcept.isEmpty }
    
    @Published var relatedTopicsEntryText: String = ""
    @Published var generatedRelatedTopics: String = ""
    var isEmptyRelatedTopicsScreen: Bool { !isThinking && generatedRelatedTopics.isEmpty }
    var hasResultRelatedTopicsScreen: Bool { !isThinking && !generatedRelatedTopics.isEmpty }
    
    @Published var definitionEntryText: String = ""
    @Published var generatedDefinition: String = ""
    var isEmptyDefinitionScreen: Bool { !isThinking && generatedDefinition.isEmpty }
    var hasResultDefinitionScreen: Bool { !isThinking && !generatedDefinition.isEmpty }
    
    @Published var articleEntryText: String = ""
    @Published var generatedArticle: String = ""
    var isEmptyArticleScreen: Bool { !isThinking && generatedArticle.isEmpty }
    var hasResultArticleScreen: Bool { !isThinking && !generatedArticle.isEmpty }
    
    @Published var expandedEntryText: String = ""
    @Published var generatedExpanded: String = ""
    var isEmptyExpandedScreen: Bool { !isThinking && generatedExpanded.isEmpty }
    var hasResultExpandedScreen: Bool { !isThinking && !generatedExpanded.isEmpty }
    
    @Published var summarizedEntryText: String = ""
    @Published var generatedSummary: String = ""
    var isEmptySummarizedScreen: Bool { !isThinking && generatedSummary.isEmpty }
    var hasResultSummarizedScreen: Bool { !isThinking && !generatedSummary.isEmpty }
    
    @Published var differencesEntryText1: String = ""
    @Published var differencesEntryText2: String = ""
    @Published var generatedDifferences: String = ""
    var isEmptyComparisonScreen: Bool { !isThinking && generatedDifferences.isEmpty }
    var hasResultComparisonScreen: Bool { !isThinking && !generatedDifferences.isEmpty }
    
    @Published var generatedNext: String = ""
    var isEmptyNextScreen: Bool { !isThinking && generatedNext.isEmpty }
    var hasResultNextScreen: Bool { !isThinking && !generatedNext.isEmpty }
    
    @Published var generatedAffirmation: String = ""
    var isEmptyAffirmationScreen: Bool { !isThinking && generatedAffirmation.isEmpty }
    var hasResultAffirmationScreen: Bool { !isThinking && !generatedAffirmation.isEmpty }
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: "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")
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        isThinking = true
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure(_):
                let output = "Oops! Error generating output."
                completion(output)
            }
        })
    }
    
    func makeNewChat() {
        send(text: "\(newChatEntryText)") { output in
            DispatchQueue.main.async {
                self.generatedNewChat = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeConcept() {
        send(text: "Generate a concept, generally a word or many, in the realm of anything, that is grounded in reality, and that may or may not be valuable to learn about. Simply provide the short concept without punctuation.") { output in
            DispatchQueue.main.async {
                self.generatedConcept = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeRelatedTopics() {
        send(text: "Generate 5 topics that are closely related to \(relatedTopicsEntryText). Simply provide the related topics separated by new line.") { output in
            DispatchQueue.main.async {
                self.generatedRelatedTopics = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeDefinition() {
        send(text: "Provide the definition of \(definitionEntryText).") { output in
            DispatchQueue.main.async {
                self.generatedDefinition = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeArticle() {
        send(text: "Generate an in-depth, grounded in reality, 1-paragraph wikipedia article for a reader who does not understand the topic of \(articleEntryText). Simply provide the generate article.") { output in
            DispatchQueue.main.async {
                self.generatedArticle = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeExpanded() {
        send(text: "Expand on the following text: \"\(expandedEntryText)\"") { output in
            DispatchQueue.main.async {
                self.generatedExpanded = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeSummary() {
        send(text: "Summarize the following text, readable by an 8th grader: \"\(summarizedEntryText)\"") { output in
            DispatchQueue.main.async {
                self.generatedSummary = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeComparison() {
        send(text: "Provide a list of differences between: \"\(differencesEntryText1)\" and \"\(differencesEntryText2)\"") { output in
            DispatchQueue.main.async {
                self.generatedDifferences = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeNext() {
        send(text: "Provide a random but important, single thing to think about on the topic of daily living, in the form of a direction for me to follow right now. Be specific.") { output in
            DispatchQueue.main.async {
                self.generatedNext = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
    
    func makeAffirmation() {
        send(text: "Generate an affirmation I can tell myself that will subtly fill me with life and smiles and that is not too confusing. Provide the affirmation without quotes.") { output in
            DispatchQueue.main.async {
                self.generatedAffirmation = output.trimmingCharacters(in: .whitespacesAndNewlines)
                self.isThinking = false
            }
        }
    }
}

enum Modules: CaseIterable, Identifiable {
    case newChat
    case randomConcept
    case relatedTopics
    case definition
    case article
    case expanded
    case summarized
    case comparison
    case next
    case affirmation
    
    var id: String { return title }
    var title: String {
        switch self {
        case .newChat: return "New Chat"
        case .randomConcept: return "Random Concept"
        case .relatedTopics: return "Related Topics"
        case .definition: return "Definition"
        case .article: return "Article"
        case .expanded: return "Expand Text"
        case .summarized: return "Summarize Text"
        case .comparison: return "Comparison"
        case .next: return "Next"
        case .affirmation: return "Affirmation"
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .newChat: return "text.bubble"
        case .randomConcept: return "lightbulb"
        case .relatedTopics: return "square.stack.3d.up"
        case .definition: return "exclamationmark.circle"
        case .article: return "book"
        case .expanded: return "plus"
        case .summarized: return "minus"
        case .comparison: return "arrow.up.arrow.down"
        case .next: return "arrowshape.right"
        case .affirmation: return "checkmark.seal"
        }
    }
}

