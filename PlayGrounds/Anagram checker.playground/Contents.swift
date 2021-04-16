import UIKit

let example1 = "debit card"
let example2 = "bad credit"
let example3 = "punishments"
let example4 = "nine thumps"

func checkForAnagram(firstString: String, secondString: String) -> Bool {
    return firstString.lowercased().sorted() == secondString.lowercased().sorted()
}

checkForAnagram(firstString: example1, secondString: example2)
checkForAnagram(firstString: example3, secondString: example4)
