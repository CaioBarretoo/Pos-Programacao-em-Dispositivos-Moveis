import Foundation

//Enum (enumeradores)
enum Compass{
    case north
    case south
    case east
    case west
}

let heading: Compass = .north
print(heading)

switch heading {
    case .north:
        print("We are heading north")
    case .south:
        print("We are heading south")
    case .east:
        print("We are headgin east")
    case .west:
        print("We are headgin west")
}

// Valor padrão
enum WeekDay: String{
    case sunday = "Domingo"
    case monday = "Segunda-Feira"
    case tuesday = "Terça-Feira"
    case wednesday = "Quarta-Feira"
    case thursday = "Quinta-Feira"
    case friday = "Sexta-Feira"
    case saturday = "Sábado"
}

let today: WeekDay = .saturday

print("Hoje é", today.rawValue)

let tomorrow = WeekDay(rawValue: "Domingo")

// Valor Associado

enum Measure{
    case weight(Double)
    case age(Int)
    case size(width: Double, height: Double)
}

let measure = Measure.size(width: 15, height: 25)

switch measure{
    case .weight(let weight):
        print("É uma medida de peso, e o peso é \(weight)")
    case .age(let age):
        print("É uma medida de idade, e a idade é \(age)")
    case .size(let width, let height):
        print("É uma medida de tamanho cuja largura é \(width) e altura é \(height)")

}


// Funções

func doNothing(){
    print("Essa função não faz nada")
}

func double(x: Int) -> Int {
    return x*2
}

double(x: 8)

func sum(a: Int, b: Int) -> Int {
    return a+b
}

print(sum(a: 5, b: 7))

func say(_ greetings: String, to person: String){
    print("\(greetings) \(person)")
}

say("Olá", to: "Pedro")

func summ(_ number1: Int, _ number2: Int) -> Int {
    return number1 + number2
}

func multiply(_ number1: Int, _ number2: Int) -> Int {
    return number1 * number2
}

func dive(_ number1: Int, _ number2: Int) -> Int {
    return number1 / number2
}

func subtract(_ number1: Int, _ number2: Int) -> Int {
    return number1 - number2
}

typealias Operation = (Int, Int) -> Int

func calculate(_ number1: Int, _ number2: Int, using operation: Operation) -> Int {
    return operation(number1, number2)
}

calculate(7, 5, using: summ)

func getOperation(named: String) -> Operation {
    switch named {
    case "soma":
        return summ
        
    case "subtração":
        return subtract
    case "divisão":
        return dive
    default:
        return multiply
    }
}

getOperation(named: "soma")(5, 4)

// Closures
/*
 {(parametro: Tipo) -> TipodoRetorno in
    códigos
 }
 */

calculate(8, 4, using: {(x: Int, y: Int) -> Int in
    return x % y
})

// Simplificando a closure

calculate(8, 4, using: {$0 % $1})
calculate(8, 4) {$0 % $1}

let names = ["Eric", "Pedro", "Caio", "Ana", "Maria"]

var uppercasedName: [String] = []
for name in names{
    uppercasedName.append(name.uppercased())
}
print(uppercasedName)

print(names.map{$0.uppercased()})

// High Order Functions

// ----------------------

// Classes vs Structs

struct Person{
    let name: String
    var age: Int
}

var felipe = Person(name: "Felipe", age: 45)
var paulo = felipe

felipe.age = 49
print(paulo.age)

// Extension
var name = "Caio Henrique Barreto Costa"
