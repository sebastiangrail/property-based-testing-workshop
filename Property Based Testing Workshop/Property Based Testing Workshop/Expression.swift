//
//  Expression.swift
//  Property Based Testing Workshop
//
//  Created by Sebastian Grail on 24/8/18.
//  Copyright © 2018 Sebastian Grail. All rights reserved.
//

import Foundation

extension String: Error {}

public indirect enum Expression {
    case value(Double)
    case unaryFunction((Double) -> Double, Expression)
    case binaryFunction((Double, Double) -> Double, Expression, Expression)
    case assignment(name: String, value: Expression, rest: Expression)
    case variable(String)
    
    public func evaluate(context: [String: Expression]) throws -> Double {
        if Thread.callStackSymbols.count > 1000 {
            throw "Approaching stack overflow"
        }
        switch self {
        case .value(let x):
            return x
        case .unaryFunction(let f, let x):
            return try f(x.evaluate(context: context))
        case .binaryFunction(let f, let x, let y):
            return try f(x.evaluate(context: context), y.evaluate(context: context))
        case .assignment(let name, let value, let rest):
            var newContext = context
            newContext[name] = value
            return try rest.evaluate(context: newContext)
        case .variable(let name):
            guard let expression = context[name] else { throw "Undeclared variable \(name)" }
            return try expression.evaluate(context: context)
        }
    }
}

extension Expression: CustomDebugStringConvertible {
    private func print(indentation: Int) -> String {
        let indent = Array(repeating: " ", count: indentation).joined()
        switch self {
        case .value(let x):
            return "\(indent)value(\(x))"
        case .unaryFunction(_, let x):
            return """
            \(indent)function(
            \(x.print(indentation: indentation + 1))
            \(indent))
            """
        case .binaryFunction(_, let x , let y):
            return """
            \(indent)function(
            \(x.print(indentation: indentation + 1)),
            \(y.print(indentation: indentation + 1))
            \(indent))
            """
        case .assignment(let name, let value, let rest):
            return """
            \(indent)let \(name) =
            \(value.print(indentation: indentation + 1))
            \(indent)in
            \(rest.print(indentation: indentation + 1))
            """
        case .variable(let name):
            return "\(indent)variable(\(name))"
        }
    }
    
    public var debugDescription: String {
        return print(indentation: 0)
    }
    
    
}

extension Expression: CustomStringConvertible {
    public var description: String {
        return debugDescription
    }
}
