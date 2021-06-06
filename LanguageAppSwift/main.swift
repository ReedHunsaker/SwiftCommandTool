//
//  main.swift
//  LanguageAppSwift
//
//  Created by Reed hunsaker on 5/26/21.
//

import Foundation

// Struct for the random words API
struct wordResponse : Decodable {
    let word : String
    let definition: String
    let pronunciation: String
}

//Struct for the english-spanish API
struct jsonResponse : Codable{
    var english : String
    var spanish : String
}

class Screen{
    //Controls the output to the user
    func menu(language: String) -> String {
        // The main menu
        var choice = "5"
        //Work in progress
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
        //Display the words that the random words API generated
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
        //Switch the language variable
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
    //Data to load JSON from a file. Work in progress. Still doesn't work
    @Published var userData = [jsonResponse]()
    
    init() {
        load()
    }
    
    func load() {
        do {
            //error happens here at file location
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
class callAPIJSON {
    //call the same JSON data through an API using python and flask
    var stringList: [String] = []
    
    func getList() -> [String]{
        //return the list of all elements of the JSON file
        return self.stringList
    }
    
    func retrieve(){
        //Gets the data from the API and puts it in the list
        print("Loading...")
        makeRequest { (res) in
            switch res{
            case.success(let words):
                
                words.forEach({ (words) in
//                    print(words.word)
//                    print(words.definition)
//                    print(words.pronunciation)
                    self.stringList.append(words.english)
                    self.stringList.append(words.spanish)
            })
            case.failure(let err):
                print("Failed to connect", err)
        }

            
        }
    }
    
    
    fileprivate func makeRequest(_ completion: @escaping (Result<[jsonResponse],Error>) -> Void) {
        // Makes a request to the python/flask api
        let urlString = "http://127.0.0.1:5000/helloworld"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            
            if let err = err {
                completion(.failure(err))
                return
            }
            
            // successful
            do {
                let words = try JSONDecoder().decode([jsonResponse].self, from: data!)
                completion(.success(words))
//                completion(words, nil)
                
            } catch let jsonError {
                completion(.failure(jsonError))
//                completion(nil, jsonError)
            }
            
            
        }.resume()    }
    
}

class callAPI {
    //Calls the API for the random words
    var stringList: [String] = []
    
    func getList() -> [String]{
        //Returns the list of random words
        return self.stringList
    }
    
    func retrieve(){
        //updates the list with the new API data
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
        //Call the random words API
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
    //Class runs the app
    var language : String
    init() {
        language = "English"
    }
    func main() {
        // Main loop of the application.
        var result = "5"
        let screen = Screen()
        var nextWord = "w"
        var wordList: [String]
        
        //Json Calls
        
//        let JSONCall = callAPIJSON()
//        JSONCall.retrieve()
//        sleep(3)
//        let spanishList = JSONCall.getList()
        
        //User press 4 to exit
        while result != "4" {
            
            
            
           
            //Main menu
            result = screen.menu(language: language)
            
            
            if result == "1"{
                //Random word menu
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
            //Works with api still a work in progress.
//            else if result == "2"{
//                var number = Int.random(in: 0...7740)
//                if number % 2 != 0{
//                    number += 1
//                }
//                let translation = number + 1
//                print(spanishList[number])
//                print(spanishList[translation])
//            }
            else if result == "3"{
                
                //Set language
                language = screen.language_menu(language: language)
            
            }
        }
    }
}

//run the application

let run_app = App()
run_app.main()



