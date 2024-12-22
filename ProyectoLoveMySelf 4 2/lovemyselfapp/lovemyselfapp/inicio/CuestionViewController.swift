//
//  CuestionViewController.swift
//  lovemyselfapp
//
//  Created by DISEÑO on 19/12/24.
//

import UIKit


struct Questiones {
    let text: String
    let answers: [String]
    let scores: [Int] // Puntos asociados a cada opción
}
class CuestionViewController: UIViewController {
    
    
    @IBOutlet weak var preguntaLabel: UILabel!
    
    
    @IBOutlet weak var opcion1: UIButton!
    
    
    @IBOutlet weak var opcion2: UIButton!
    
    
    @IBOutlet weak var opcion3: UIButton!
    
    
    
    @IBOutlet weak var progreso: UIProgressView!
    
    @IBOutlet weak var siguienteBoton: UIButton!
    
    
    // Variables para el control del test
            var questions: [Questiones] = []               // Lista de preguntas
            var currentQuestionIndex: Int = 0             // Índice de la pregunta actual
            var totalScore: Int = 0               // Puntuación acumulada
            var selectedAnswerIndex: Int? = nil   // Índice de la respuesta seleccionada
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Crear preguntas 
                        questions = [
                            
                            Questiones(text: "¿Cómo te sientes últimamente para realizar las cosas?",
                                       answers: ["Me siento nervioso (a) y preocupado (a)", "Me siento cansado (a) y con poco interés  en las cosas que solían gustarme", "Me siento estresado (a) y mis pensamientos están abrumados."],
                                       scores: [3, 2, 1]),
                            Questiones(text: "¿Qué situaciones has experimentado en las últimas semanas?", answers: ["Problemas de concentración al realizar diferentes actividades", "Problemas para conciliar el sueño o dormir demasiado", "Problemas para controlar tus emociones"], scores: [3, 2, 1]),
                            Questiones(text: "¿Qué sentimiento es el que más deseas experimentar en tu vida?",
                                       answers: ["Tranquilidad, confianza en mi mismo (a)", "Relajado (a) y enérgico (a)", "Satisfacción y felicidad     "], scores: [3, 2, 1]),
                            Questiones(text: "¿Cómo describiría tu comportamiento en estas últimas semanas?",
                                       answers: ["Estoy tan inquieto/a que es difícil permanecer sentado/a tranquilamente ", "Siento falta de amor propio, como si fuera un fracaso, que me decepcionaría mí mismo/a o a mi familia ", "Me muevo o hablo tan despacio que los demás podrían haberlo notado, o lo contrario me muevo y  hablo muy rápido "],
                                       scores: [3, 2, 1])
                           
                        
                        ]
                        
                        // Mostrar la primera pregunta
                        showQuestion()
                    }
    
    // Mostrar la pregunta y las respuestas
                func showQuestion() {
                    let currentQuestion = questions[currentQuestionIndex]
                    preguntaLabel.text = currentQuestion.text
                    
                    opcion1.setTitle(currentQuestion.answers[0], for: .normal)
                    opcion2.setTitle(currentQuestion.answers[1], for: .normal)
                    opcion3.setTitle(currentQuestion.answers[2], for: .normal)
                    
                    // Restaurar el estilo de los botones
                    resetButtonStyles()
            
                    // Actualizar la barra de progreso
                            let progress = Float(currentQuestionIndex) / Float(questions.count)
                            progreso.setProgress(progress, animated: true)
                            
                            
                            siguienteBoton.isHidden = true
                            selectedAnswerIndex = nil
                        }
                        
                       
                        func resetButtonStyles() {
                            let buttons = [opcion1, opcion2, opcion3]
                            buttons.forEach { button in
                                button?.backgroundColor = .systemBlue
                                button?.isEnabled = true
                            }
    }
    
    
   
    
    @IBAction func answerSeleccion(_ sender: UIButton) {
        // Color del botón seleccionado a blanco
            sender.backgroundColor = .white

            
            let buttons = [opcion1, opcion2, opcion3]
            buttons.forEach { button in
                button?.isEnabled = false
            }

            
            siguienteBoton.isHidden = false

           
            if let selectedIndex = buttons.firstIndex(of: sender) {
                selectedAnswerIndex = selectedIndex
            }
        
        
        
        
        
        
    }
    
    
    
    
    @IBAction func siguienteQuestion(_ sender: UIButton) {
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
                           resultText = "Tu bienestar emocional es excelente, puedes disfrutar por todo el contenido de la app."
                           resultImageName = "bienestar"
                       } else if totalScore >= 5 {
                           resultText = "Tu bienestar emocional es bueno, pero puedes tomar accion, te recomendamos realiar ejercicios de meditacion y relajacion."
                           resultImageName = "bienestar2"
                       } else {
                           resultText = "Considera enfocarte más en tu bienestar emocional, te recomendamos la seccion d emusica relajante, recursos informativos y ejercicios que te podrian beneficiar."
                           resultImageName = "bien3"
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
