//
//  Graph.swift
//  PFXLeetCodeTests
//
//  Created by PFXStudio on 2019. 2. 10..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class Graph: NSObject {
    class Node {
        let data: Int
        var lists = Array<Node>()
        var marked = false
        init(_ data:Int) {
            self.data = data
        }
    }
    
    var nodes = [Node]()
    init(_ size:Int) {
        for i in 0..<size {
            self.nodes.append(Node(i))
        }
    }
    
    func addEdge(left: Int, right: Int) {
        let leftNode = self.nodes[left]
        let rightNode = self.nodes[right]
        var check = leftNode.lists.contains { (node) -> Bool in
            return node.data == right
        }
        
        if check == false {
            leftNode.lists.append(rightNode)
        }
        
        check = rightNode.lists.contains(where: { (node) -> Bool in
            return node.data == left
        })
        
        if check == false {
            rightNode.lists.append(leftNode)
        }
    }
    
    func dfs(_ index:Int) {
        let root = nodes[index]
        var stack = Stack<Node>()
        stack.push(root)
        root.marked = true
        print("root : \(root.data)")
        while stack.isEmpty == false {
            let target = stack.pop()
            for targetNode in target!.lists {
                if targetNode.marked == false {
                    stack.push(targetNode)
                    targetNode.marked = true
                    print("val : \(targetNode.data)")
                }
            }
        }
    }

    func visitDfs(_ index:Int) -> [Int] {
        var visits = [Int]()
        let root = nodes[index]
        var stack = Stack<Node>()
        stack.push(root)
        root.marked = true
        print("root : \(root.data)")
        while stack.isEmpty == false {
            let target = stack.pop()
            for targetNode in target!.lists {
                if targetNode.marked == false {
                    stack.push(targetNode)
                    targetNode.marked = true
                    visits.append(targetNode.data)
                }
            }
        }
        
        return visits
    }
}
