//
//  SheetSize.swift
//  ellavevirtual
//
//  Created by Digital on 22/07/21.
//  Copyright © 2021 Scotiabank México. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import CoreGraphics

public enum SheetSize: Equatable {
    case fixed(CGFloat)
    case fullscreen
    case percent(Float)
    case marginFromTop(CGFloat)
}

#endif // os(iOS) || os(tvOS) || os(watchOS)
