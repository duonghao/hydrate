//
//  WidgetConfiguration-Exts.swift
//  HydrateWidgetExtension
//
//  Created by Hao Duong on 31/10/2023.
//

import Foundation
import SwiftUI

extension WidgetConfiguration
{
    func contentMarginsDisabledIfAvailable() -> some WidgetConfiguration
    {
        if #available(iOSApplicationExtension 17.0, *)
        {
            return self.contentMarginsDisabled()
        }
        else
        {
            return self
        }
    }
}
