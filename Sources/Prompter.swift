
import Foundation

/** A callback when command is fired
 
 The closure that tells whether command is running or not.
 */
public typealias CommandClosure = ((_ started: Bool)->())

/** A callback when suggestion is fired
 
 The closure that tells whether suggestion is running or not.
 */
public typealias SuggestionClosure = ((_ started: Bool)->())

/**
 Custom logging closure to check for debugs information.
 
 The closure sends the `text` that will be logged.
 */
public typealias LogClosure = ((_ text: String)->())


/// `Prompt` is a utility class for user suggestion or command.
open class Prompt {
    
    fileprivate var isRunningCommandCenter: Bool = false
    fileprivate var _commandPrefixes = [":"]
    fileprivate var logClosure: LogClosure? = nil
    fileprivate var commandClosure: CommandClosure? = nil
    fileprivate var suggestionClosure: SuggestionClosure? = nil
    
    fileprivate init() { }
    
    /**
     Man in the middle (MITM) incoming text to parse and check for commands or suggestions
     
     - parameter text: input text to parse
     */
    open func mitm(text: String) {
        let sanitizedText = text.trimmingCharacters(in: .whitespaces)
        if sanitizedText.characters.count > 0 {
            if commandClosure != nil {
                _ensureCommandPrefix(text: sanitizedText)
            }
        }
    }
    
}

fileprivate extension Prompt {
    
    fileprivate func _ensureCommandPrefix(text: String) {
        if _commandPrefixes.contains(text[0]) {
            logClosure?("Command found")
            _setCommandCenter()
            let words = text.components(separatedBy: " ")
            if words.count > 0 {
                _resetCommandCenter()
            }
        } else {
            _resetCommandCenter()
        }
    }
    
    fileprivate func _setCommandCenter() {
        isRunningCommandCenter = true
    }
    
    fileprivate func _resetCommandCenter() {
        isRunningCommandCenter = false
    }
    
}

private extension String {
    
    subscript(i: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: i)
        return String(self.characters[index])
    }
    
}

/** Factory class to crate `Prompt` for command or user suggestion.
 
    - SeeAlso `Prompt`
 */
public struct PromptFactory {
    
    private var prompt: Prompt = Prompt()
    
    public func setLogClosure(closure: @escaping LogClosure) -> PromptFactory {
        prompt.logClosure = closure
        return self
    }
    
    public func setCommandClosure(closure: @escaping CommandClosure) -> PromptFactory {
        prompt.commandClosure = closure
        return self
    }
    
    public func setSuggestionClosure(closure: @escaping SuggestionClosure) -> PromptFactory {
        prompt.suggestionClosure = closure
        return self
    }
    
    public func build() -> Prompt {
        return prompt
    }
    
}

// Usage example
//let prompt = PromptFactory().setLogClosure { (text) in
//    print(text)
//}.setCommandClosure { (started) in
//    
//}.setSuggestionClosure { (started) in
//    
//}.build()


