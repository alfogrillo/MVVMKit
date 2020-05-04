// ___FILEHEADER___

import MVVMKit

final class ___VARIABLE_viewModelName___: CollectionViewViewModel, CoordinatedViewModel {
    var binder: AnyCollectionViewBinder<___VARIABLE_viewModelName___>?
    var sections: [SectionViewModel] = []
    
    let coordinator: ___VARIABLE_coordinatorName___
    
    init(coordinator: ___VARIABLE_coordinatorName___) {
        self.coordinator = coordinator
    }
}
