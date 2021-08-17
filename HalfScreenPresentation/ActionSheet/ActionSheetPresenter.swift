//
//  ActionSheetPresenter.swift
//  ellavevirtual
//
//  Created by Digital on 22/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

import Foundation

class ActionSheetPresenter  {
    
    // MARK: Properties
    weak var view: ActionSheetPresenterToViewProtocol?
    var interactor: ActionSheetPresenterToInteractorProtocol?
    var router: ActionSheetPresenterToRouterProtocol?
    
}

extension ActionSheetPresenter: ActionSheetViewToPresenterProtocol {
    // TODO: implement presenter methods
    func viewDidLoad() {
    }
}

extension ActionSheetPresenter: ActionSheetInteractorToPresenterProtocol {
    // TODO: implement interactor output methods
}
