//
//  PatientDetailTablListAddCoachViewController.swift
//  Admin
//
//  Created by pekkapekka on 2021/4/12.
//

import Foundation
import UIKit

protocol PatientDetailTabListAddCoachViewControllerProtocol: NSObjectProtocol {
    func onChangedHeight(newHeight: CGFloat)
    func onTouchSendButton(addCoachList: [(speed: Int?, time: Int?)])
}

class PatientDetailTabListAddCoachViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: PatientDetailTabListAddCoachViewControllerProtocol?
    var addCoachList: [(speed: Int?, time: Int?)] = [(nil, nil)]
    var isAddingCoachCount = false
    enum Section: Int, CaseIterable {
        case input
        case sendButton
    }
    let inputCellHeight: CGFloat = 164.0
    let sendButtonHeight: CGFloat = 40.0
    
    var previousEditingFieldIndex = 0

    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 28, right: 0)
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        onChangeHeight()
    }
    
    func reloadDataViewAndChangedHeight() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: addCoachList.count - 1, section: 0)], with: .fade)
        tableView.reloadSections(IndexSet.init(integer: 0), with: .fade)
        tableView.endUpdates()
        onChangeHeight()
        UIView.setAnimationsEnabled(true)
    }
    
    @objc func onChangeHeight() {
        let newHeight = tableView.contentSize.height + tableView.contentInset.top + tableView.contentInset.bottom
        delegate?.onChangedHeight(newHeight: newHeight)
    }
    
    func scrollToBottom() {
        tableView.scrollToBottom(animated: false)
        isAddingCoachCount = false
    }
    
    //MARK: 第一次開跳第一個，第二次開就用舊的，除非不在畫面上，就跳畫面慎第一個，按新增時跳新增那個
    //MARK: 為了尋找適合位置，自動跳到該欄位，不需額外點擊
    func focusOnPreviousEditingTextfield() {
        let previousEditingIndexpath = IndexPath.init(row: previousEditingFieldIndex, section: Section.input.rawValue)
        let cell = self.tableView.cellForRow(at: previousEditingIndexpath)
        if let cell = cell {
            (cell as! PatientDetailTabListInputCell).setBecomeFirstResponder()
        } else {
            let cell = tableView.visibleCells.first
            if let cell = cell as? PatientDetailTabListInputCell {
                cell.setBecomeFirstResponder()
            }
        }
    }
}

extension PatientDetailTabListAddCoachViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .input:
            return addCoachList.count
        case .sendButton:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Input")! as! PatientDetailTabListInputCell
            let isLast = (addCoachList.count == indexPath.row + 1)
            if addCoachList.count > indexPath.row {
                    cell.setCell(title: "第 \(indexPath.row + 1) 組"
                                 , suggestSpeed: addCoachList[indexPath.row].speed
                                 , suggestTime: addCoachList[indexPath.row].time
                                 , isAddCoachButtonHidden: !isLast
                                 , index: indexPath.row)
            }
            cell.delegate = self
            return cell
        case .sendButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendButton") as! PatientDetailTablListSendButtonCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        ()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == Section.input.rawValue) ?  inputCellHeight : sendButtonHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == Section.input.rawValue) ?  inputCellHeight : sendButtonHeight
    }
}

extension PatientDetailTabListAddCoachViewController: PatientDetailTabListInputCellProtocol {
    func onTouchAddCoachCountButton() {
        isAddingCoachCount = true
        addCoachList.append((nil, nil))
        reloadDataViewAndChangedHeight()
        self.tableView.isScrollEnabled = false
        previousEditingFieldIndex = addCoachList.count - 1
        focusOnPreviousEditingTextfield()
        self.tableView.isScrollEnabled = true
    }
    
    func onTypeSpeedTime(speed: Int?, time: Int?, index: Int) {
        addCoachList[index] = (speed, time)
    }
    
    func onTextFieldDidBeginEditing(index: Int) {
        //MARK: 防止已有focus時，滑動到，點擊會錯誤scroll
        previousEditingFieldIndex = index
        tableView.setContentOffset(tableView.contentOffset, animated: false)
    }
    
    func onTextFieldDidEndEditing() {
        ()
    }
}

extension PatientDetailTabListAddCoachViewController: PatientDetailTablListSendButtonCellProtocol {
    func onTouchSendButton(){
        delegate?.onTouchSendButton(addCoachList: addCoachList)
        addCoachList = [(nil, nil)]
        reloadDataViewAndChangedHeight()
    }
}
