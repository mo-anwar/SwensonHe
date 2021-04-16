import UIKit

func fibNumSteps(numSteps: Int)-> [Int] {
    var sequence = [0, 1]
    if numSteps <= 1 {
        return sequence
    }
    for _ in 0...numSteps - 1 {
        let first = sequence[sequence.count - 2]
        let second = sequence.last!
        sequence.append(first + second)
    }
    return sequence
}
fibNumSteps(numSteps: 4)

func fibRecursionNumSteps(numSteps: Int, first: Int, second: Int)-> [Int] {
    var isFirstRound = true
    
    if  isFirstRound {
        isFirstRound = false
    }
    if numSteps == 0 {
        return []
    }
    return [first + second] + fibRecursionNumSteps(numSteps: numSteps - 1, first: second, second: first + second)
}

[0,1] + fibRecursionNumSteps(numSteps: 9, first: 0, second: 1)

func fib(_ n: Int) -> Int {
    guard n > 1 else { return n }
    return fib(n-1) + fib(n-2)
}

func fibRecursion(numSteps: Int)-> [Int] {
    var sequence = [Int]()
    for i in 0...numSteps {
        sequence.append(fib(i))
    }
    return sequence
}

fibRecursion(numSteps: 5)
