import Foundation

// REPL: Read Eval Process Loop


print("Olá pessoal!")
var name = "Caio"
var sum  = 5 + 9


// Documentação

/// Documentação COMMAND + OPTION + /
/// - Parameters:
///   - url: URL contendo o endereço do endpoint a ser consumido
///   - method: método getpoint
///   - parameter: teste
///   - header: teste
/*func request(_ url: URL,
             method: String = "GET",
             parameter: [String: Any]? nil,
             header: [String: Any]? = nil){
    
}*/

// Variáveis

var accountValue = -350.0
accountValue = 1


// Pascal Case (Classes) exemplo : Função
// Camel Case (Objetos, Métodos) exemplo : accountValue

// Int, String, Bool, Double, Int, UInt (Sem números negativos)
class Person{
    let name: String
    var age: UInt
    
    init(name: String, age: UInt){
        self.name = name
        self.age = age
    }

}

var caio = Person(name: "Caio Barreto", age: 21)
caio.age = 22


// Fortemente tipada o Swift

// Inferência de Tipo
let letter: Character = "a"
let isSwiftCool = true
let average = 7.85

// Concatenação de String
let firstname = "Caio"
let lastname =  "Barreto"
let fullName = firstname + " " + lastname

// Interpolação de String
let caioBio = "\(firstname) \(lastname), \(caio.age) anos"

// Tupla
//let address = "Rua Pindamonhangaba, 500, 01278-010"
//print(address)

//let address = ("Rua Pindamonhangaba", 500, "01278-010")
//print("Ele mora no número \(address.1)")

let address: (name: String, number: Int, zipCode: String) = ("Rua Pindamonhangaba", 500, "01278-010")
print("Ele mora no número \(address.number)")

// Decomposição de Tupla
// let (nameStreet, numberStreet, _) Não pega a ultima variavel
let (nameStreet, numberStreet, zipCode) = address

// Optional
// nil fica nulo mas está esperando um valor
var driverLicense: String? = nil

print(driverLicense)

driverLicense = "CAIOX-33"
print(driverLicense)

// Unwrap (Desembrulhar) - desembrulhar o option
//if let driverLicense2 = driverLicense{
//    print(driverLicense2)
//}
if let driverLicense{
    print(driverLicense)
} else{
    print("Ele não tem carteira de motorista")
}

// Operador de coalescência nula (??)
let newDriverLicense = driverLicense ?? "outra coisa"
print(newDriverLicense)

let number1 = "12"
let number2 = "27"
let number3 = "6"

let newNumber = Int(number1) ?? Int(number2) ?? Int(number3) ?? 0

// Jeito Vida Loka
// Force unwrap - Evitar usar

let anotherNumber = Int(number1)!

// Coleção
// Array, Dictionary, Set
var shoppingList: [String] = ["Arroz", "Carne", "Feijão", "Milho"]
var emptyArray: [String] = []

//Adicionar
shoppingList.append("Sabão")
shoppingList += ["Pera", "Uva", "Leite"]
if shoppingList.count > 1 {
    shoppingList.insert("Maçã", at: 1)
}

print(shoppingList)

// Total de Elementos
shoppingList.count
shoppingList.isEmpty

// Removendo
//shoppingList.remove(at: 3)
let removedItem = shoppingList.remove(at: 3)
print(removedItem)
//shoppingList.removeLast()

// Pesquisar Elementos

if shoppingList.contains("Leite"){
    print("O leite das crianças está garantido")
}

if let index = shoppingList.firstIndex(of: "Leite"){
    print("O Leite está na posição \(index) do array")
}

print(shoppingList[3])

// Dicionário
var states: [String: String] = [
    "SP": "São Paulo",
    "MG": "Minas Gerais",
    "RJ": "Rio de Janeiro",
    "PA": "Pará"
]

var emptyDictionary: [Int: String] = [:]

states.count
states.isEmpty
//states["PA"]
if let para = states["PA"]{
    print(para)
}

states["DF"] = "Distrito Federal"
states["PA"] = nil

print(states)

// Set
var movies: Set<String> = ["Matrix", "Vingadores", "Jurassic Park"]
var myWifeMovies: Set<String> = ["Homem-Aranha", "Vingadores", "Jurassic Park", "De Volta Para o Futuro"]

movies.count
movies.isEmpty

//movies.insert("Substância")

let (inserted, _) = movies.insert("Substância")
if inserted {
    print("Eba, o filme foi inserido")
} else {
    print("Xiiim já estava lá")
}

movies.contains("Jurassic Park")
//movies.remove("Matrix")
print(movies)

let favoriteMovies = movies.intersection(myWifeMovies)
print(favoriteMovies)

let allmovies = movies.union(myWifeMovies)
print(allmovies)

movies = movies.subtracting(myWifeMovies)
print(movies)

// IF ELSE

let grade = 7.0

if grade > 6.0 {
    print("Passou")
} else {
    print("Reprovou")
}

var temperature = 19, climate = ""

if temperature <= 0{
    climate = "Muito Frio"
} else if temperature < 14 {
    climate = "Frio"
} else {
    climate = "Só Deus sabe"
}

// Switch

var newLetter = "O", letterType = ""

switch newLetter.lowercased() {
    case "a", "e", "i", "o", "u":
        letterType = "Vogal"
    default:
        letterType = "Consoante"
}

let speed = 95.0
switch speed {
    case 0..<20:
        print("Primeira marcha")
    case 20..<40:
        print("Primeira marcha")
    case 40..<50:
        print("Primeira marcha")
    default:
        print("Quarta Marcha")
}

switch newLetter.lowercased() {
    case "a"..."m":
        print("Primeira metade do alfabeto")
    default:
        print("Segunda metade do alfabeto")
}

//While
var count = 1
while count <= 5 {
    print(count)
    count += 1
}


// For in

//for (int i = 0; i <= 10; i++) {
//    print(i)
//}

for item in shoppingList{
    print(item)
}

for number in 1...10{
    print(number)
}

for (sigla, nome) in states {
    print(sigla, nome)
}


var 🐶 = "Billy"
var 🐩 = "Paçoca"
var 💩 = "cocô"

print("O \(🐶) e o \(🐩) vivem fazendo \(💩)")
