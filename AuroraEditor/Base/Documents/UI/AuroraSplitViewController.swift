//
//  AuroraSplitViewController.swift
//  Aurora Editor
//
//  Created by Fumiya Tanaka on 2023/02/12.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import Cocoa

class AuroraSplitViewController: NSSplitViewController {

    let prefs: AppPreferencesModel

    init(prefs: AppPreferencesModel) {
        self.prefs = prefs
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func splitViewDidResizeSubviews(_ notification: Notification) {
        guard let targetDividerIndex = notification.userInfo?["NSSplitViewDividerIndex"] as? Int else {
            return
        }
        switch targetDividerIndex {
        case 1:
            // InspectorSidebar
            let panel = splitView.subviews[2]
            let inspectorSidebarWidth = panel.frame.size.width
            Log.debug("prefs.preferences.general.inspectorSidebarWidth:", inspectorSidebarWidth)
            if inspectorSidebarWidth.isZero {
                break
            }
            prefs.preferences.general.inspectorSidebarWidth = inspectorSidebarWidth
        default:
            break
        }
    }
}
