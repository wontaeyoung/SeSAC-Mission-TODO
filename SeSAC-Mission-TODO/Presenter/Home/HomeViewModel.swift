//
//  HomeViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import Foundation
import KazUtility

final class HomeViewModel: ViewModel {
  
  // MARK: - Mock
  static let mockTags: [String] = ["Tag 1", "Tag 2", "Tag3", "Tag4"]
  static let mockData: [TodoItem] = (1...20).map { n in
    return .init(
      id: UUID(),
      title: "Task \(n)",
      memo: "메모 \(n)",
      dueDate: .init(timeIntervalSinceNow: 86400 * Double(n)),
      tags: [mockTags.randomElement()!],
      states: [.allCases.randomElement()!],
      priority: .allCases.randomElement()!
    )
  }
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil) {
    self.coordinator = coordinator
  }
  
  // MARK: - Bindable
  lazy var todoItems: Bindable<[TodoItem]> = .init(value: Self.mockData)
  
  // MARK: - Method
  func filter(by state: TodoState) -> [TodoItem] {
    return todoItems.current.filter { $0.states.contains(state) }
  }
  
  func filteredCount(by state: TodoState) -> Int {
    return filter(by: state).count
  }
}

