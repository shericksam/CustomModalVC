//
//  GenericActionSheetPresenter.swift
//  ellavevirtual
//
//  Created by Digital on 18/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

import Foundation

class GenericActionSheetPresenter  {
    
    // MARK: Properties
    weak var view: GenericActionSheetPresenterToViewProtocol?
    var interactor: GenericActionSheetPresenterToInteractorProtocol?
    var router: GenericActionSheetPresenterToRouterProtocol?
    
}

extension GenericActionSheetPresenter: GenericActionSheetViewToPresenterProtocol {
    // TODO: implement presenter methods
    func viewDidLoad() {
    }
}

extension GenericActionSheetPresenter: GenericActionSheetInteractorToPresenterProtocol {
    // TODO: implement interactor output methods
}
