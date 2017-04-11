//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var nAmount = 0
    if to == "USD" {
        if currency == "GBP" {
            nAmount = amount * 2
        } else if currency == "EUR" {
            nAmount = amount * 2/3
        } else if currency == "CAN" {
            nAmount = amount * 4/5
        } else {
            nAmount = amount
        }
    }
    if to == "GBP" {
        if currency == "USD" {
            nAmount = amount / 2
        } else if currency == "EUR" {
            nAmount = amount / 3
        } else if currency == "CAN" {
            nAmount = amount * 2/5
        } else {
            nAmount = amount
        }
    }
    if to == "EUR" {
        if currency == "GBP" {
            nAmount = amount * 3
        } else if currency == "USD" {
            nAmount = amount * 3/2
        } else if currency == "CAN" {
            nAmount = amount * 5/6
        } else {
            nAmount = amount
        }
    }
    if to == "CAN" {
        if currency == "GBP" {
            nAmount = amount * 5/2
        } else if currency == "EUR" {
            nAmount = amount * 6/5
        } else if currency == "USD" {
            nAmount = amount * 5/4
        } else {
            nAmount = amount
        }
    }
    return Money(amount: nAmount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    var temp = Money(amount: amount, currency: currency)
    temp = temp.convert(to.currency)
    let nAmount = to.amount + temp.amount
    return Money(amount: nAmount, currency: to.currency)
  }
    
  public func subtract(_ from: Money) -> Money {
    var temp = Money(amount: amount, currency: currency)
    temp = temp.convert(from.currency)
    let nAmount = from.amount - temp.amount
    return Money(amount: nAmount, currency: from.currency)
  }
}


////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let pay):
        return Int(Double(hours) * pay)
    case .Salary(let pay):
        return pay
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let pay):
        type = JobType.Hourly(pay + amt)
    case .Salary(let pay):
        type = JobType.Salary(pay + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {return _job}
    set(value) {
        if age >= 16{
            _job = value
        } else {
            _job = nil
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {return _spouse}
    set(value) {
        if age >= 18 {
            _spouse = value
        } else {
            _spouse = nil
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]")
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1._spouse == nil && spouse2._spouse == nil {
        spouse1._spouse = spouse2
        members.append(spouse1)
        spouse2._spouse = spouse1
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    var legal = false
    for i in members {
        if i.age > 21 {
            legal = true
        }
    }
    if legal {
        members.append(child)
    }
    return legal
  }
  
  open func householdIncome() -> Int {
    var totalIncome = 0;
    for i in members {
        if i.job != nil {
            totalIncome += i.job!.calculateIncome(40 * 50)
        }
    }
    return totalIncome
  }
}

