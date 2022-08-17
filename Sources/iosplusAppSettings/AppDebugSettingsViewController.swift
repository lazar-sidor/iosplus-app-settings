//
//  AppSettingsViewController.swift
//
//  Created by Lazar Sidor on 13.01.2022.
//

#if os(iOS)
import UIKit
import SafariServices

private enum AppDebugSettingsCellIdentifier: String {
    case singleSelectionCellId
    case actionCellId
}

public struct AppSettingsViewConfiguration {
    public var actions: [AppSettingsAction] = []
    public var settings: [AppSettingsEntry] = []
    public var pageTitle: String? = nil

    public init(actions: [AppSettingsAction], settings: [AppSettingsEntry], pageTitle: String? = nil) {
        self.actions = actions
        self.settings = settings
        self.pageTitle = pageTitle
    }
}

public final class AppDebugSettingsViewController: UITableViewController {
    var settings: [AppSettingsEntry] = []
    var actions: [AppSettingsAction] = []
    var selection: ((_ updated: Bool) -> Void)?
    var pageTitle: String? = nil
    
    public static func showAppSettings(configuration: AppSettingsViewConfiguration, context: UIViewController, selectionBlock: @escaping ((_ updated: Bool) -> Void)) {
        let controller = AppDebugSettingsViewController(configuration: configuration, selectionBlock: selectionBlock)
        
        let settingsNavigation = UINavigationController.init(rootViewController: controller)
        settingsNavigation.modalPresentationStyle = .fullScreen
        
        context.present(settingsNavigation, animated: true, completion: nil)
    }
    
    public convenience init(configuration: AppSettingsViewConfiguration, selectionBlock: @escaping ((_ updated: Bool) -> Void)) {
        if #available(iOS 13.0, *) {
            self.init(style: .insetGrouped)
        } else {
            // Fallback on earlier versions
            self.init(style: .grouped)
        }
        self.settings = configuration.settings
        self.actions = configuration.actions
        self.pageTitle = configuration.pageTitle
        self.selection = selectionBlock
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppDebugSettingsCellIdentifier.singleSelectionCellId.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppDebugSettingsCellIdentifier.actionCellId.rawValue)
        setupNavigationBar()
    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return actions.count + settings.count
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < actions.count {
            return 1
        }

        let group: AppSettingsEntry = settings[section - actions.count]
        return group.supportedOptions().count
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < actions.count {
            return nil
        }

        let group: AppSettingsEntry = settings[section - actions.count]
        return group.title()
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < actions.count {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: AppDebugSettingsCellIdentifier.actionCellId.rawValue)!
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            cell.textLabel?.text = actions[indexPath.row].title.capitalized

            return cell
        }

        let currentSetting: AppSettingsEntry = settings[indexPath.section - actions.count]

        if currentSetting.selectionType() == .singleSelection {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: AppDebugSettingsCellIdentifier.singleSelectionCellId.rawValue)!
            cell.accessoryType = currentSetting.hasSelectedOptionAtIndex(indexPath.row) ? .checkmark : .none
            cell.selectionStyle = .default
            cell.textLabel?.text = currentSetting.displayNameForOptionAtIndex(indexPath.row).capitalized
            
            return cell
        }

        return UITableViewCell()
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section < actions.count {
            handleAction(indexPath: indexPath)
            return
        }

        handleSettingsSelection(indexPath: indexPath)
    }
}

// MARK: - Private
private extension AppDebugSettingsViewController {
    private func handleAction(indexPath: IndexPath) {
        let action = actions[indexPath.row]
        if action.isExternalLink() {
            showSafaryWebView(url: action.url, context: self)
            return
        }

        if let selection = action.selection {
            selection(action)
        }
    }

    private func handleSettingsSelection(indexPath: IndexPath) {
        let currentSetting: AppSettingsEntry = settings[indexPath.section - actions.count]
        currentSetting.saveWithSupportedValue(at: indexPath.row)
        tableView.reloadData()

        if let selection = selection {
            selection(true)
        }
    }

    private func showSafaryWebView(url: URL?, context: UIViewController) {
        if url != nil {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let controller = SFSafariViewController(url: url!, configuration: config)
            context.present(controller, animated: true)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Settings"
        if let pageTitle = pageTitle {
            navigationItem.title = pageTitle
        }

        let rightItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func doneAction() {
        dismiss(animated: true, completion: nil)
    }
}
#endif
