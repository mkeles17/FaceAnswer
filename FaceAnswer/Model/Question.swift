//
//  Question.swift
//  FaceAnswer
//

import Foundation

struct Question: Codable {
    let questionBody: String
    let answers: [Answer]
}
