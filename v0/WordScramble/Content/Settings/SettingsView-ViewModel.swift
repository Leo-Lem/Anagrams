//
//  SettingsView-ViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Combine

extension SettingsView {
    @MainActor class ViewModel: SuperViewModel {
        var language: Language {
            get { defaults.language }
            set { userManager.setPreference(language: newValue) }
        }
        var minuteLimit: Int {
            get { defaults.timelimit / 60 }
            set { userManager.setPreference(timelimit: (1...60 ~= newValue) ? newValue * 60 : nil) }
        }
        var autosave: Bool {
            get { defaults.autosave }
            set { userManager.setPreference(autosave: newValue) }
        }
        
        var userManager: UserManager { model.userManager }
        var defaults: Defaults { userManager.user.defaults }
        
        func newGame() { model.gameManager.setNextRootAndStartNewGame() }
    }
}
