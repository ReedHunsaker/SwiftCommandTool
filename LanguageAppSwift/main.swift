//
//  main.swift
//  LanguageAppSwift
//
//  Created by Reed hunsaker on 5/26/21.
//

import Foundation

struct wordResponse : Decodable {
    let word : String
    let definition: String
    let pronunciation: String
}

struct jsonResponse : Codable{
    var english : String
    var spanish : String
}

class Screen{
    func menu(language: String) -> String {
        var choice = "5"
        //add greeting
        print("Current language: " + language)
        let menu_string = """
            
            1) Learn
            2) Study
            3) Set Language
            4) Quit
            
            >
            """
        print(menu_string)
        if let menu_input = readLine(){
            choice = menu_input
        }
        return choice
    }
    func learn_menu(words: [String]) -> String{
        var choice = "w"
        let learnString = """
            
            Word: \(words[0])
            
            Definition: \(words[1])
            
            Pronunciation: \(words[2])
            
            Enter 'w' to get a new word
            
            Enter Any other key to coninue
            """
        
        print(learnString)
        
        if let menu_input = readLine(){
            choice = menu_input
        }
        return choice
        
       
    }
    func language_menu(language : String) -> String {
        var language = language
        print("Current language : " + language)
        print()
        print("""
            1. English
            2. Spanish
            
            
            """)
        if let language_input = readLine(){
            if language_input == "1"{
                language = "English"
            }
            else if language_input == "2"{
                language = "Spanish"
            }
        }
        return language
    }
}


public class DataLoader {
    @Published var userData = [jsonResponse]()
    
    init() {
        load()
    }
    
    func load() {
        do {
            let fileLocation = Bundle.main.url(forResource: "data", withExtension: "json")
            print("We are in")
            // do catch in case of error
            
                let data = try Data(contentsOf: fileLocation!)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([jsonResponse].self, from: data)
                print("Loading...")
                sleep(10)
                self.userData = dataFromJson
            }catch{
                print(error)
            }
    }
    
//    func sort() {
//        self.userData = self.userData.sorted(by: { $0.english < $1.english})
//    }
}
 

class callAPI {
    var stringList: [String] = []
    
    func getList() -> [String]{
        return self.stringList
    }
    
    func retrieve(){
        print("Loading...")
        makeRequest { (res) in
            switch res{
            case.success(let words):
                
                words.forEach({ (words) in
//                    print(words.word)
//                    print(words.definition)
//                    print(words.pronunciation)
                    self.stringList.append(words.word)
                    self.stringList.append(words.definition)
                    self.stringList.append(words.pronunciation)
            })
            case.failure(let err):
                print("Failed to connect", err)
        }

            
        }
    }
    
    
    fileprivate func makeRequest(_ completion: @escaping (Result<[wordResponse],Error>) -> Void) {
        let urlString = "https://random-words-api.vercel.app/word"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            
            if let err = err {
                completion(.failure(err))
                return
            }
            
            // successful
            do {
                let words = try JSONDecoder().decode([wordResponse].self, from: data!)
                completion(.success(words))
//                completion(words, nil)
                
            } catch let jsonError {
                completion(.failure(jsonError))
//                completion(nil, jsonError)
            }
            
            
        }.resume()    }
    
}


class App{
    var language : String
    init() {
        language = "English"
    }
    func main() {
        var result = "5"
        let screen = Screen()
        var nextWord = "w"
        var wordList: [String]
//        let spanishV = DataLoader()
        while result != "4" {
            
            
            
           
            //Main menu
            result = screen.menu(language: language)
            
            
            // add menu items 1 and 2
            if result == "1"{
                nextWord = "w"
                while nextWord == "w"{
                    let newCall = callAPI()
                    newCall.retrieve()
                    sleep(3)
                    wordList = newCall.getList()
                    nextWord = nextWord.lowercased()
                    nextWord = screen.learn_menu(words: wordList)
                }


            }
//            else if result == "2"{
//                print(spanishV.userData)
//            }
            else if result == "3"{
                
                //Set language
                language = screen.language_menu(language: language)
            
            }
        }
    }
}

let run_app = App()
run_app.main()

