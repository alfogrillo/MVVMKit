// ___FILEHEADER___

import Combine
import MVVMKit

final class ___VARIABLE_viewModelName___: DiffableTableViewViewModel, CoordinatedViewModel {
    typealias SectionType = Section
    
    let coordinator: ___VARIABLE_coordinatorName___
    
    init(coordinator: ___VARIABLE_coordinatorName___) {
        self.coordinator = coordinator
    }
    
    var snapshot: AnyPublisher<SnapshotAdapter, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    enum Section {
        case main
    }
}
