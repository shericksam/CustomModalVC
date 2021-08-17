//
//  GenericActionSheetRouter.swift
//  ellavevirtual
//
//  Created by Digital on 18/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

import Foundation
import UIKit

class GenericActionSheetRouter: GenericActionSheetPresenterToRouterProtocol {
    
    class func createGenericActionSheetViewController(controller: UIViewController, initSize: SheetSize = .percent(0.40)) -> GenericActionSheetViewController {
        let viewController: GenericActionSheetViewController = .init(controller: controller, initSize: initSize)
        let presenter: GenericActionSheetViewToPresenterProtocol & GenericActionSheetInteractorToPresenterProtocol = GenericActionSheetPresenter()
        let interactor: GenericActionSheetPresenterToInteractorProtocol = GenericActionSheetInteractor()
        let router: GenericActionSheetPresenterToRouterProtocol = GenericActionSheetRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return viewController
    }
}
