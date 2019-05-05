import Intents

class IntentHandler: INExtension, INStartWorkoutIntentHandling {
    
    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        
       // guard let spokenPhrase = intent.workoutName?.spokenPhrase else {return }
        
        let response = INStartWorkoutIntentResponse(code: .continueInApp, userActivity: nil)
        
        completion(response)
    }
}
