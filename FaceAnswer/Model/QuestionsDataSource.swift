//
//  questionsDataSource.swift
//  FaceAnswer
//

import Foundation

class QuestionsDataSource {
    
    private var questionsArray: [Question] = []
    
    init () {
        questionsArray.append(Question(questionBody: "What is 2 + 2 ?", answers: [
            Answer(text: "4", correct: true),
            Answer(text: "3", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 4 * 6 ?", answers: [
            Answer(text: "24", correct: true),
            Answer(text: "16", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 9 - 5 ?", answers: [
            Answer(text: "2", correct: false),
            Answer(text: "4", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 18 / 3 ?", answers: [
            Answer(text: "8", correct: false),
            Answer(text: "6", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 16 + 28 ?", answers: [
            Answer(text: "44", correct: true),
            Answer(text: "34", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 15 * 8 ?", answers: [
            Answer(text: "140", correct: false),
            Answer(text: "120", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 72 - 39 ?", answers: [
            Answer(text: "33", correct: true),
            Answer(text: "43", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 99 / 9 ?", answers: [
            Answer(text: "10", correct: false),
            Answer(text: "11", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 14 + 77 ?", answers: [
            Answer(text: "91", correct: true),
            Answer(text: "92", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 15 * 20 ?", answers: [
            Answer(text: "300", correct: true),
            Answer(text: "350", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 55 - 18 ?", answers: [
            Answer(text: "36", correct: false),
            Answer(text: "37", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 100 / 20 ?", answers: [
            Answer(text: "6", correct: false),
            Answer(text: "5", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 33 + 77 ?", answers: [
            Answer(text: "110", correct: true),
            Answer(text: "100", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 44 * 5 ?", answers: [
            Answer(text: "220", correct: true),
            Answer(text: "200", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 89 - 37 ?", answers: [
            Answer(text: "53", correct: false),
            Answer(text: "52", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 117 / 13 ?", answers: [
            Answer(text: "9", correct: true),
            Answer(text: "19", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 56 + 47 ?", answers: [
            Answer(text: "93", correct: false),
            Answer(text: "103", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 85 * 2 ?", answers: [
            Answer(text: "170", correct: true),
            Answer(text: "160", correct: false)
        ]))
        questionsArray.append(Question(questionBody: "What is 63 - 55 ?", answers: [
            Answer(text: "9", correct: false),
            Answer(text: "8", correct: true)
        ]))
        questionsArray.append(Question(questionBody: "What is 52 / 2 ?", answers: [
            Answer(text: "26", correct: true),
            Answer(text: "36", correct: false)
        ]))
    }
    
    func getRandomQuizQuestions() -> [Question] {
        questionsArray = questionsArray.shuffled()
        return Array(questionsArray.prefix(upTo: 10))
    }
}
