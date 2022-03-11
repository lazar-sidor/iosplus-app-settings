//
//  AppSettingsAction.swift
//  Created by Lazar Sidor on 16.02.2022.
//

import Foundation

public struct AppSettingsAction {
    var url: URL?
    var title: String

    public init(url: URL?, title: String) {
        self.url = url
        self.title = title
    }

    public func isExternalLink() -> Bool {
        return url != nil
    }
}
