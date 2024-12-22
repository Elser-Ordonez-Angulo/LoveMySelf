//
//  TestViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 5/12/24.
//

import UIKit
struct Question {
    let text: String
    let answers: [String]
    let scores: [Int] // Puntos asociados a cada opción
class TestViewController: UIViewController {
        
        
        @IBOutlet weak var preguntaLabel: UILabel!
 
        
        @IBOutlet weak var progressView: UIProgressView!
        
        @IBOutlet weak var optionButton1: UIButton!
        
        @IBOutlet weak var optionButton2: UIButton!
        
        @IBOutlet weak var optionButton3: UIButton!
        
        
        @IBOutlet weak var nextButton: UIButton!
        
        // Variables para el control del test
        var questions: [Question] = [] // Lista de preguntas
        var currentQuestionIndex: Int = 0 // Índice de la pregunta actual
        var totalScore: Int = 0 // Puntuación acumulada
        var selectedAnswerIndex: Int? = nil // Índice de la respuesta seleccionada
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Crear preguntas de ejemplo
            questions = [
                Question(text: "¿Cómo te sientes últimamente para realizar las cosas?", answers: [
                    "Me siento nervioso(a) y preocupado(a)",
                    "Me siento cansado(a) y con poco interés en las cosas que solían gustarme",
                    "Me siento estresado(a) y mis pensamientos están abrumados"
                ], scores: [3, 2, 1]),
                
                Question(text: "¿Qué situaciones has experimentado en las últimas semanas?", answers: [
                    "Problemas de concentración al realizar diferentes actividades",
                    "Problemas para conciliar el sueño o dormir demasiado",
                    "Problemas para controlar tus emociones"
                ], scores: [3, 2, 1]),
                
                Question(text: "¿Qué sentimiento es el que más deseas experimentar en tu vida?", answers: [
                    "Tranquilidad, confianza en mí mismo(a)",
                    "Relajado(a) y enérgico(a)",
                    "Satisfacción y felicidad"
                ], scores: [3, 2, 1]),
                Question(text: "¿Qué  vida?", answers: [
                    "Tranquilidad,en mí mismo(a)",
                    "Relajado(a) y enérgico(a)",
                    "Satisfacción y felicidad"
                ], scores: [3, 2, 1]),
                
                
                Question(text: "¿Cómo describiría tu comportamiento en estas últimas semanas?", answers: [
                    "Estoy tan inquieto/a que es difícil permanecer sentado/a tranquilamente",
                    "Siento falta de amor propio, como si fuera un fracaso",
                    "Me muevo o hablo tan despacio que los demás podrían haberlo notado"
                ], scores: [3, 2, 1])
            ]
            
            // Mostrar la primera pregunta
            showQuestion()
        }
        
        // Función para mostrar la pregunta y las respuestas
        func showQuestion() {
            let currentQuestion = questions[currentQuestionIndex]
            preguntaLabel.text = currentQuestion.text
            optionButton1.setTitle(currentQuestion.answers[0], for: .normal)
            optionButton2.setTitle(currentQuestion.answers[1], for: .normal)
            optionButton3.setTitle(currentQuestion.answers[2], for: .normal)
            
            // Restaurar el estilo de los botones
            resetButtonStyles()
            
            // Actualizar la barra de progreso
            let progress = Float(currentQuestionIndex) / Float(questions.count)
            progressView.setProgress(progress, animated: true)
            
            // Ocultar el botón "Siguiente" hasta que se seleccione una respuesta
            nextButton.isHidden = true
            selectedAnswerIndex = nil
        }
        
        // Función para restaurar el estilo de los botones
        func resetButtonStyles() {
            let buttons = [optionButton1, optionButton2, optionButton3]
            buttons.forEach { button in
                button?.backgroundColor = .systemBlue
                button?.isEnabled = true
            }
            
        }
        
        
        
       
        @IBAction func answerSelected(_ sender: UIButton){
                       // Cambiar el color del botón seleccionado a verde
                       sender.backgroundColor = .white

                       // Deshabilitar todos los botones para evitar múltiples selecciones
                       let buttons = [optionButton1, optionButton2, optionButton3]
                       buttons.forEach { button in
                           button?.isEnabled = false
                       }

                       // Mostrar el botón "Siguiente"
                       nextButton.isHidden = false

                       // Guardar el índice del botón seleccionado
                       if let index = buttons.firstIndex(of: sender) {
                           selectedAnswerIndex = index
                       }
                   }
        
        
        
            
        @IBAction func nextQuestion(_ sender: UIButton) {
        

            
          
            // Guardar la puntuación de la respuesta seleccionada
            if let selectedAnswerIndex = selectedAnswerIndex {
                let currentQuestion = questions[currentQuestionIndex]
                totalScore += currentQuestion.scores[selectedAnswerIndex]
            }
            
            // Pasar a la siguiente pregunta o mostrar el resultado
            if currentQuestionIndex + 1 < questions.count {
                currentQuestionIndex += 1
                showQuestion()
            } else {
                showResult()
            }
        }
        
        // Función para mostrar el resultado de la prueba
        func showResult() {
            // Determinar el resultado según la puntuación total
            var resultText: String
            var resultImageName: String
            
            if totalScore >= 8 {
                resultText = "¡Tu bienestar emocional es excelente!"
                resultImageName = "clasica"
            } else if totalScore >= 5 {
                resultText = "Tu bienestar emocional es bueno, pero puedes mejorarlo."
                resultImageName = "correr"
            } else {
                resultText = "Considera enfocarte más en tu bienestar emocional."
                resultImageName = "cuidado"
            }
            
            // Crear la pantalla de resultados y pasar el texto y la imagen
            if let resultVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                resultVC.resultText = resultText
                resultVC.resultImageName = resultImageName
                navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
}
