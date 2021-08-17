//
//  ActionSheetContract.swift
//  ellavevirtual
//
//  Created by Digital on 22/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

import Foundation
import UIKit

protocol ActionSheetViewToPresenterProtocol: class {
    var view: ActionSheetPresenterToViewProtocol? { get set }
    var interactor: ActionSheetPresenterToInteractorProtocol? { get set }
    var router: ActionSheetPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
}

protocol ActionSheetPresenterToViewProtocol: class {
}

protocol ActionSheetPresenterToRouterProtocol: class {
    
    static func createActionSheetViewController(controller: UIViewController, initSize: SheetSize) -> ActionSheetViewController
    static func createActionSheetViewController(view: UIView, initSize: SheetSize) -> ActionSheetViewController
}

protocol ActionSheetInteractorToPresenterProtocol: class {
}

protocol ActionSheetPresenterToInteractorProtocol: class {
    var presenter: ActionSheetInteractorToPresenterProtocol? { get set }
}
