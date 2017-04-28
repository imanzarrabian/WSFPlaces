//: Playground - noun: a place where people can play

import UIKit

let array = [1, 2, 3, 4, 5]

//METHODE 1 : MAP
let timesTwo = array.map { (elem) -> Int in
    return elem * 2
}

print(timesTwo)





//METHODE 2 : FOR-LOOP
var timesTwoBis = [Int]()
for elem in array {
    timesTwoBis.append(elem * 2)
}

print(timesTwoBis)

struct Place {
    let name: String
    let address: String
}

let placeJson = ["name" : "Toto", "address" : "59, rue Nationale"]

let onePlace = Place(name: placeJson["name"]!, address: placeJson["address"]!)

print(onePlace.name)
print(onePlace.address)

