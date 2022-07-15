//
//  AppSettingsAction.swift
//  Created by Lazar Sidor on 16.02.2022.
//

import Foundation

public typealias AppSettingsActionSelection = ((_ action: AppSettingsAction) -> Void)

public struct AppSettingsAction {
    var url: URL?
    var tag: Int = 0
    var title: String
    var selection: AppSettingsActionSelection?

    public init(url: URL? = nil, title: String, tag: Int = 0, selection: AppSettingsActionSelection? = nil) {
        self.url = url
        self.title = title
        self.selection = selection
        self.tag = tag
    }

    public func isExternalLink() -> Bool {
        return url != nil
    }
}
