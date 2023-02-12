//
//  InspectorSidebar.swift
//  Aurora Editor
//
//  Created by Austin Condiff on 3/21/22.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

// The main Inspector View that handles showing the different
// views that the inspector has like the file inspector, history and
// Quick Help.
struct InspectorSidebar: View {

    @Environment(\.controlActiveState)
    private var activeState

    @EnvironmentObject
    private var workspace: WorkspaceDocument

    @State
    private var selection: Int = 0

    @State
    private var idealWidth: Double = 250

    /// `fixingViewSize` is necessary to forcely fix the initial size of ``InspectorSidebar``.
    /// `fixingViewSize` becomes `false` after `View/onApepar` is called.
    @State
    private var fixingViewSize: Bool = true

    let prefs: AppPreferencesModel

    var body: some View {
        VStack {
            if let item = workspace.selectionState.openFileItems.first(where: { file in
                file.tabID == workspace.selectionState.selectedId
            }) {
                if let codeFile = workspace.selectionState.openedCodeFiles[item] {
                    switch selection {
                    case 0:
                        FileInspectorView(workspaceURL: workspace.fileURL!,
                                          fileURL: codeFile.fileURL!.path)
                        .frame(maxWidth: .infinity)
                    case 1:
                        HistoryInspector(workspaceURL: workspace.fileURL!,
                                         fileURL: codeFile.fileURL!.path)
                    case 2:
                        QuickHelpInspector().padding(5)
                    default: EmptyView()
                    }
                }
            } else {
                NoSelectionView()
            }
        }
        .frame(
            minWidth: 250,
            idealWidth: idealWidth,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .top
        )
        .fixedSize(horizontal: fixingViewSize, vertical: false)
        .isHidden(!prefs.preferences.general.keepInspectorSidebarOpen)
        .safeAreaInset(edge: .top) {
            InspectorSidebarToolbarTop(selection: $selection)
                .padding(.bottom, -8)
        }
        .onReceive(prefs.$preferences.map(\.general.inspectorSidebarWidth), perform: { sidebarWidth in
            idealWidth = sidebarWidth
        })
        .onAppear {
            // waiting current que is necessary to assert that View rendering is correctly finished.
            DispatchQueue.main.async {
                fixingViewSize = false
            }
        }
        .background(
            EffectView(.windowBackground, blendingMode: .withinWindow)
        )
        .opacity(activeState == .inactive ? 0.45 : 1)
    }
}
