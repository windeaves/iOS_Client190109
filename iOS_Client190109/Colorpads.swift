//
//  Colorpads.swift
//  TodoCard
//
//  Created by 唐子轩 on 2018/9/23.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue  = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    struct InterfaceColor {
        
        // Using [iOS 7 colors] as reference.
        // http://ios7colors.com/
        static let lightBlack: UIColor  = .init(hex: 0x4A4A4A)
        static let black: UIColor       = .init(hex: 0x000000)
        static let darkBlack: UIColor   = .init(hex: 0x1F1F21)
        static let lightGray: UIColor   = .init(hex: 0xDBDDDE)
        static let darkGray: UIColor    = .init(hex: 0x8E8E93)
        static let lightYellow: UIColor = .init(hex: 0xFFDB4C)
        static let lightPurple: UIColor = .init(hex: 0xC86EDF)
        static let lightGreen: UIColor  = .init(hex: 0xA4E786)
        static let lightPink: UIColor   = .init(hex: 0xFFD3E0)
        
        // Using [iOS Human Interface Guidelines] as reference.
        // https://developer.apple.com/ios/human-interface-guidelines/visual-design/color/
        static let red: UIColor      = .init(hex: 0xff3b30)
//        static let orange: UIColor   = .init(hex: 0xff9500)
        static let orange: UIColor   = .init(hex: 0xE48308)
        static let green: UIColor    = .init(hex: 0x4cd964)
        static let blue: UIColor     = .init(hex: 0x007aff)
        static let purple: UIColor   = .init(hex: 0x5856d6)
        static let yellow: UIColor   = .init(hex: 0xffcc00)
        static let tealBlue: UIColor = .init(hex: 0x5ac8fa)
        static let pink: UIColor     = .init(hex: 0xff2d55)
        static let white: UIColor    = .init(hex: 0xffffff)
        
        //self-made
        static let naviBlue: UIColor = .init(hex: 0x02407c)
        static let darkRed: UIColor  = .init(hex: 0xa30312)
        
        //iPhone XS Colorpad
        static let goldenWXS: UIColor = .init(hex: 0xffe5da)
        static let goldXS: UIColor    = .init(hex: 0xe5b28a)
        static let silverXS: UIColor  = .init(hex: 0xa09ea1)
        
        //iPhone XR Colorpad
        static let blueXR: UIColor   = .init(hex: 0x3fa7e1)
        static let redXR: UIColor    = .init(hex: 0xb81524)
        static let coralXR: UIColor  = .init(hex: 0xfc7561)
        static let yellowXR: UIColor = .init(hex: 0xf7d046)
        static let whiteXR: UIColor  = .init(hex: 0xfbfbfb)
        
        //Xcode Colorpad
        static let cyanXcode: UIColor     = .init(hex: 0x2a2b36)
        static let darkPinkXcode: UIColor = .init(hex: 0xdf2da0)
        static let purpleXcode: UIColor   = .init(hex: 0x6544e9)
        static let greenXcode: UIColor    = .init(hex: 0x51c34f)
        static let oliGreenXcode: UIColor = .init(hex: 0x93c76a)
        static let orangeXcode: UIColor   = .init(hex: 0xf7994b)
        
        //macOS Colorpad
        static let coralCross_macOS: UIColor = .init(hex: 0xff5a52)
        static let greenMax_macOS: UIColor   = .init(hex: 0x53c22b)
        static let yellowMin_macOS: UIColor  = .init(hex: 0xe6c02a)
        
        //Microsoft Colorpad
        static let errorBlue_Micro: UIColor  = .init(hex: 0x100797)
        static let errorBlueN_Micro: UIColor = .init(hex: 0x1d64ad)
        
        static let greenLogo_Micro: UIColor  = .init(hex: 0x7cb402)
        static let redLogo_Micro: UIColor    = .init(hex: 0xeb4d21)
        static let blueLogo_Micro: UIColor   = .init(hex: 0x089ee8)
        static let yellowLogo_Micro: UIColor = .init(hex: 0xf6b304)
        
        //Pokemon Colorpad
        static let red_Pkm: UIColor   = .init(hex: 0xf90200)
        static let White_Pkm: UIColor = .init(hex: 0xf8f8f8)
        
        static let red_Pikachu: UIColor = .init(hex: 0xef2ce2)
        static let darYellow_Pikachu: UIColor = .init(hex: 0xda932e)
        static let brown_Pikachu: UIColor = .init(hex: 0x7e1c07)
        
        static let darkGreen: UIColor = .init(hex: 0x026838)
        static let RRed: UIColor = .init(hex: 0xbf1e2e)
    }
}
