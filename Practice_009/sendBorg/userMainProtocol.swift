//
//  userMainProtocol.swift
//  Practice_009
//
//  Created by 鄭郁潔 on 2021/4/24.
//
import Foundation
import UIKit

protocol userMainViewProtocol: BaseViewControllerProtocol {
    func onBindMainResult(mainResult: PostBorg)
}

protocol userMainPresenterProtocol: NSObjectProtocol {
    func postBorg(userId:String, postbeat: Int, postborg: Int, prebeat: Int, preborg: Int, step: Int, timestamp: String)
}

