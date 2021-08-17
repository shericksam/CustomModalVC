//
//  ActionSheetViewController.swift
//  ellavevirtual
//
//  Created by Digital on 22/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

import Foundation
import UIKit

class ActionSheetViewController: UIViewController {

    // MARK: Properties
    var presenter: ActionSheetViewToPresenterProtocol?
    
    public var initSize: SheetSize = .percent(0.50)
    public var currentSize: CGFloat = 0
    public private(set) var contentActionSheetView: UIView
    private var keyboardHeight: CGFloat = 0
    
    public init(controller: UIViewController, initSize: SheetSize = .percent(0.50)) {
        self.contentActionSheetView = controller.view
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.initSize = initSize
    }
    
    public init(view: UIView, initSize: SheetSize = .percent(0.50)) {
        self.contentActionSheetView = view
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.initSize = initSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        self.registerKeyboardObservers()
        setupPanGesture()
        
        let newHeight: CGFloat = self.height(for: initSize)
        self.defaultHeight = newHeight
        self.currentContainerHeight = newHeight
        containerViewHeightConstraint?.constant = newHeight
        self.currentSize = newHeight
        view.layoutIfNeeded()
    }
    
    lazy var closeButton: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "darkClose"), for: .normal)
        btn.addTarget(self, action: #selector(handleCloseAction), for: .touchUpInside)
        btn.tintColor = .darkGray
        return btn
    }()
    
    lazy var closeStackView: UIStackView = {
        let spacer: UIView = .init()
        let stackView: UIStackView = .init(arrangedSubviews: [spacer, closeButton])
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        return stackView
    }()
    
    lazy var systemBackgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer: UIView = .init()
        spacer.backgroundColor = systemBackgroundColor
        let stackView: UIStackView = .init(arrangedSubviews: [closeStackView, contentActionSheetView, spacer])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = systemBackgroundColor
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    
    lazy var dimmedView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    var hasTopNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }

    // Constants
    var defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    var containerStackCloseConstraint: NSLayoutConstraint?
    var cornerRadiusViewConstraint: NSLayoutConstraint?
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
//            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerStackCloseConstraint = contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
//        cornerRadiusViewConstraint =
        containerView.layer.masksToBounds = true
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        containerStackCloseConstraint?.isActive = true
    }
    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation: CGPoint = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
//        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown: Bool = translation.y > 0
//        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight: CGFloat = currentContainerHeight - translation.y
        self.currentSize = newHeight
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                hideKeyboard()
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                containerView.layer.cornerRadius = 16
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
                changeTopPadding(20)            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
                changeTopPadding(20)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
                let height: CGFloat = getStatusBarHeight()
                changeTopPadding(height)
                containerView.layer.cornerRadius = 0
            }
        default:
            break
        }
        
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window: UIWindow? = view.window
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
        
        let height: CGFloat = getStatusBarHeight()
        changeTopPadding(hasTopNotch ? height : 20)
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {  [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func changeTopPadding(_ value: CGFloat) {
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.containerStackCloseConstraint?.constant = value
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func height(for size: SheetSize?) -> CGFloat {
        guard let size = size else { return 0 }
        let contentHeight: CGFloat
        let fullscreenHeight: CGFloat = UIScreen.main.bounds.height
        switch (size) {
            case .fixed(let height):
                contentHeight = height + self.keyboardHeight
            case .fullscreen:
                contentHeight = fullscreenHeight
            case .percent(let percent):
                contentHeight = (self.view.bounds.height) * CGFloat(percent) + self.keyboardHeight
            case .marginFromTop(let margin):
                contentHeight = (self.view.bounds.height) - margin + self.keyboardHeight
        }
        return min(fullscreenHeight, contentHeight)
    }
    
    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDismissed(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShown(_ notification: Notification) {
        guard let info: [AnyHashable: Any] = notification.userInfo,
              let keyboardRect: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let windowRect: CGRect = self.view.convert(self.view.bounds, to: nil)
        let actualHeight: CGFloat = windowRect.maxY - keyboardRect.origin.y
        self.adjustForKeyboard(height: actualHeight, from: notification)
    }
    
    @objc func keyboardDismissed(_ notification: Notification) {
        self.adjustForKeyboard(height: 0, from: notification)
        self.hideKeyboard()
    }
    
    private func adjustForKeyboard(height: CGFloat, from notification: Notification) {
        containerViewHeightConstraint?.constant = currentSize + height
        view.layoutIfNeeded()
    }
}

extension ActionSheetViewController: ActionSheetPresenterToViewProtocol {
    // TODO: implement view output methods
}
