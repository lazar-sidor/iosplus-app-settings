//
//  AppSettingsAction.swift
//  Created by Lazar Sidor on 16.02.2022.
//

import Foundation

struct AppSettingsAction {
    var url: URL?
    var title: String

    func isExternalLink() -> Bool {
        return url != nil
    }
}
