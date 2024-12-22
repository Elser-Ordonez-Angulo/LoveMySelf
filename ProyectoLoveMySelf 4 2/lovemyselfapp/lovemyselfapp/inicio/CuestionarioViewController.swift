//
//  CuestionarioViewController.swift
//  lovemyselfapp
//
//  Created by DAMII on 5/12/24.
//

import UIKit

struct Questione {
    let text: String
    let answers: [String]
    let scores: [Int] // Puntos asociados a cada opción
}


class CuestionarioViewController: UIViewController {
    
    
    @IBOutlet weak var preguntalabel: UILabel!
    @IBOutlet weak var optionButon1: UIButton!
    @IBOutlet weak var optionButon2: UIButton!
    @IBOutlet weak var optionButon3: UIButton!
    @IBOutlet weak var progresView: UIProgressView!
    @IBOutlet weak var nextButon: UIButton!
    
    // Variables para el control del test
            var questions: [Questione] = []               // Lista de preguntas
            var currentQuestionIndex: Int = 0             // Índice de la pregunta actual
        var totalScore: Int = 0               // Puntuación acumulada
            var selectedAnswerIndex: Int? = nil   // Índice de la respuesta seleccionada
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Crear preguntas de ejemplo
                        questions = [
                            Questione(text: "¿Cómo te sientes emocionalmente?", answers: ["Feliz", "Neutral", "Triste"], scores: [3, 2, 1]),
                            Questione(text: "¿Qué tan motivado te sientes hoy?", answers: ["Muy motivado", "Normal", "Poco motivado"], scores: [3, 2, 1]),
                            Questione(text: "¿Cómo describirías tu nivel de energía?", answers: ["Alto", "Moderado", "Bajo"], scores: [3, 2, 1])
                        ]
                        
                        // Mostrar la primera pregunta
                        showQuestion()
                    }
    
    // Función para mostrar la pregunta y las respuestas
                func showQuestion() {
                    let currentQuestion = questions[currentQuestionIndex]
                    preguntalabel.text = currentQuestion.text
                    
                    optionButon1.setTitle(currentQuestion.answers[0], for: .normal)
                    optionButon2.setTitle(currentQuestion.answers[1], for: .normal)
                    optionButon3.setTitle(currentQuestion.answers[2], for: .normal)
                    
                    // Restaurar el estilo de los botones
                    resetButtonStyles()
            
                    // Actualizar la barra de progreso
                            let progress = Float(currentQuestionIndex) / Float(questions.count)
                            progresView.setProgress(progress, animated: true)
                            
                            // Ocultar el botón "Siguiente" hasta que se seleccione una respuesta
                            nextButon.isHidden = true
                            selectedAnswerIndex = nil
                        }
                        
                        // Función para restaurar el estilo de los botones
                        func resetButtonStyles() {
                            let buttons = [optionButon1, optionButon2, optionButon3]
                            buttons.forEach { button in
                                button?.backgroundColor = .systemBlue
                                button?.isEnabled = true
                            }
                        }
                    
                
    
    
      
    
    
    @IBAction func answerSelecte(_ sender: UIButton) {
        // Cambiar el color del botón seleccionado a verde
            sender.backgroundColor = .white

            // Deshabilitar todos los botones de manera segura
            let buttons = [optionButon1, optionButon2, optionButon3]
            buttons.forEach { button in
                button?.isEnabled = false  // Solo deshabilita si no es nil
            }

            // Mostrar el botón "Siguiente"
            nextButon.isHidden = false

            // Guardar el índice del botón seleccionado
            if let selectedIndex = buttons.firstIndex(of: sender) {
                selectedAnswerIndex = selectedIndex
            }
        }
    
    @IBAction func nextQuestons(_ sender: UIButton) {
        // Guardar la puntuación de la respuesta seleccionada de manera segura
           if let selectedAnswerIndex = selectedAnswerIndex {
               let currentQuestion = questions[currentQuestionIndex]
               totalScore += currentQuestion.scores[selectedAnswerIndex]
           } else {
               print("No se seleccionó ninguna respuesta")
               return
           }

           // Pasar a la siguiente pregunta o mostrar el resultado
           if currentQuestionIndex + 1 < questions.count {
               currentQuestionIndex += 1
               showQuestion()
           } else {
               showResult()
           }
       }
               
               // Función para mostrar el resultado del test
               func showResult() {
                   var resultText: String
                       var resultImageName: String

                       if totalScore >= 8 {
                           resultText = "Tu bienestar emocional es excelente"
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
                       } else {
                           print("No se pudo instanciar el ResultViewController")
                       }
                   }
            
                  }
