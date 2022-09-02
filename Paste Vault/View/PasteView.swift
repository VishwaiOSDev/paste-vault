//
//  ContentView.swift
//  PasteVault
//
//  Created by Vishweshwaran on 17/07/22.
//

import SwiftUI
import FontKit

struct PasteView<ViewModel>: View where ViewModel: Pasteable {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var themeSwitcher: ThemeSwitcher
    @State var onHoverInQuitButton: Bool = false
    @State var listType: ListType = .all
    
    @SectionedFetchRequest(
        fetchRequest: Paste.getAllPaste(),
        sectionIdentifier: \.sections,
        animation: .easeInOut(duration: 0.3))
    private var allPasteboardItems: SectionedFetchResults<String, Paste>
    @SectionedFetchRequest(
        fetchRequest: Paste.getPinnedPaste(),
        sectionIdentifier: \.sections,
        animation: .easeInOut(duration: 0.3))
    private var pinnedPasteboardItems: SectionedFetchResults<String, Paste>
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                    .padding(.horizontal)
                pickerView
                    .padding(.horizontal)
                lazyListView
                    .embedInScrollView()
                Spacer()
            }
            .padding()
        }
        .background(themeSwitcher.selectedTheme.brandColor.padding(-80))
        .frame(width: 400, height: 500)
    }
    
    private var headerView: some View {
        HStack(alignment: .center) {
            Text("Paste Vault")
                .font(.inter(.bold(size: 18)))
                .foregroundColor(themeSwitcher.selectedTheme.textColor)
            Spacer()
            themeChangerView
            terminateButton
                .onTapGesture(perform: terminateApplication)
        }
    }
    
    private var themeChangerView: some View {
        Picker("", selection: $themeSwitcher.themeName) {
            ForEach(ThemeName.allCases, id: \.self) { theme in
                Text(theme.title)
            }
        }
        .frame(width: 90)
        .pickerStyle(.menu)
    }
    
    private var pickerView: some View {
        Picker("", selection: $listType) {
            ForEach(ListType.allCases, id: \.self) { listType in
                Text(listType.title)
                    .tag(listType)
            }
        }
        .labelsHidden()
        .pickerStyle(.segmented)
    }
    
    private var lazyListView: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            pasteboardItemListView
        }
        .padding()
    }
    
    private var pasteboardItemListView: some View {
        ForEach(getListFilterType(for: listType)) { section in
            Section(header: sectionHeader(text: section.id.capitalized)) {
                ForEach(section, id: \.self) { item in
                    if item.wrappedContent != "NO DATA" {
                        PasteCell(
                            content: item.wrappedContent,
                            isPinned: item.isPinned,
                            didTapOnCellOrCopy: { value in
                                didTapCopyButton(content: value)
                            },
                            didTapDelete: {
                                didTapDeleteButton(at: item.wrappedId)
                            },
                            didTapPin: {
                                didTapPinButton(at: item.wrappedId)
                            }
                        )
                        .padding(.all, 4)
                        .contextMenu {
                            contextMenuStack(
                                text: item.wrappedContent,
                                id: item.wrappedId,
                                isPinned: item.isPinned
                            )
                        }
                    }
                }
            }
        }
    }
    
    func sectionHeader(text: String) -> some View {
        HStack {
            Text(text)
                .padding([.leading, .bottom], 4)
                .font(.inter(.semibold(size: 14)))
                .foregroundColor(themeSwitcher.selectedTheme.textColor)
            Spacer()
        }
        .background(themeSwitcher.selectedTheme.brandColor)
    }
    
    private var terminateButton: some View {
        HoverButton(
            "Quit",
            onHover: $onHoverInQuitButton,
            bgColor: themeSwitcher.selectedTheme.secondaryColor,
            hoverColor: themeSwitcher.selectedTheme.contrastSecondaryColor
        )
        .onTapGesture {
            viewModel.terminateApplication()
        }
    }
    
    @ViewBuilder
    private func contextMenuStack(text: String, id: UUID, isPinned: Bool) -> some View {
        contextCopyButton(text)
        contextPinButton(at: id, isPinned: isPinned)
        contextDeleteButton(at: id)
        contextDeleteAllButton()
    }
    
    private func contextCopyButton(_ text: String) -> some View {
        Button("Copy") {
            didTapCopyButton(content: text)
        }
    }
    
    private func contextPinButton(at id: UUID, isPinned: Bool) -> some View {
        Button(isPinned ? "Unpin" : "Pin") {
            didTapPinButton(at: id)
        }
    }
    
    private func contextDeleteButton(at id: UUID) -> some View {
        Button("Delete") {
            didTapDeleteButton(at: id)
        }
    }
    
    private func contextDeleteAllButton() -> some View {
        Button("Delete All") {
            didTapDeleteAllButton()
        }
    }
    
    private func getListFilterType(for filter: ListType) -> SectionedFetchResults<String, Paste> {
        switch filter {
        case .all:
            return allPasteboardItems
        case .pinned:
            return pinnedPasteboardItems
        }
    }
    
    private func didTapDeleteButton(at id: UUID) {
        viewModel.deletePasteItem(at: id)
    }
    
    private func didTapDeleteAllButton() {
        viewModel.deleteAllPasteItems()
    }
    
    private func didTapCopyButton(content: String) {
        viewModel.copyTheSelectedItem(content)
    }
    
    private func didTapPinButton(at id: UUID) {
        viewModel.pinTheSelectedItem(id)
    }
    
    private func terminateApplication() {
        viewModel.terminateApplication()
    }
}

struct PasteView_Previews: PreviewProvider {
    
    static var previews: some View {
        let service = PasteboardService()
        let viewModel = PasteViewModel(pasteboardService: service, storage: .init(.inMemory))
        Group {
            PasteView<PasteViewModel>()
                .environmentObject(viewModel)
                .environmentObject(ThemeSwitcher())
            PasteView<PasteViewModel>()
                .environmentObject(viewModel)
                .environmentObject(ThemeSwitcher())
                .preferredColorScheme(.light)
        }
    }
}
