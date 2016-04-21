//: [Previous](@previous)

import Foundation

import SISNotes
print("开始刷新...")
import SISFramework

import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let viewController = AlbumsListViewController()
XCPlaygroundPage.currentPage.liveView = viewController
print("刷新完成")

//let onclickview = OnclickLikeViewController()
//onclickview.view.backgroundColor = UIColor.whiteColor()
//XCPlaygroundPage.currentPage.liveView = onclickview
