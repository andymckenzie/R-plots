//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, test"

var myVariable = 42

myVariable = 50


let myConstant = 42

var ratingList = ["Poor", "Fine", "Good", "Excellent"]

ratingList[1] = "OK"

ratingList

let emptyArray = [String]()

let vegetable = "red pepper"

switch vegetable {

case "celery":
    let vegetableComment = "Add some raisins and make ants on a log."
case "cucumber", "watercress":
    let vegetableComment = "That would make a good tea sandwich."
case let x where x.hasSuffix("pepper"):
    let vegetableComment = "Is it a spicy \(x)?"
default:
    let vegetableComment = "Everything tastes good in soup."
}

class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()

let redSquare = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
redSquare.backgroundColor = UIColor.blueColor()


let blueSquare = UIView(frame: CGRect(x: -10, y: 10, width: 44, height: 44))
blueSquare.backgroundColor = UIColor.blueColor()