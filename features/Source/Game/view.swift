//  Created by Leopold Lemmermann on 16.01.22.

import ComposableArchitecture
import SwiftUIComponents

@ViewAction(for: Singleplayer.self)
public struct SingleplayerView: View {
  @Bindable public var store: StoreOf<Singleplayer>
  
  public var body: some View {
    VStack {
      HStack {
        Button(.localizable(.previous), systemImage: "chevron.left") { send(.previousRootTapped) }
          .labelStyle(.iconOnly)
          .disabled(focussingRoot || !store.previousAvailable)

        HStack {
          Text(store.game.root)
            .lineLimit(1)
            .font(.largeTitle)
            .onLongPressGesture { editingRoot = true }
            .opacity(editingRoot ? 0 : 1)

          // this is for centering the word.
          Button(.localizable(.previous), systemImage: "chevron.right") {}
            .labelStyle(.iconOnly)
            .hidden()
            .accessibilityHidden(true)
        }
        .overlay {
          if editingRoot {
            SubmittableTextField(
              LocalizedStringKey(store.game.root), text: $store.newRoot, submittable: store.isValidRoot
            ) {
              send(.newRootSubmitted)
              editingRoot = false
            }
            .focused($focussingRoot)
            .font(.largeTitle)
          }
        }
      }

      WordList(store.game.words)
        .disabled(editingRoot)
        .notification(.localizable(.rootAlertTitle), item: $store.rootAlert)
        .notification(.localizable(.wordAlertTitle), item: $store.wordAlert)

      SubmittableTextField(
        .localizable(.enterWord(store.game.root)), text: $store.newWord, submittable: store.isValidWord
      ) {
        send(.newWordSubmitted)
        focussingWord = true
      }
      .focused($focussingWord)
      .textFieldStyle(.roundedBorder)
      .disabled(store.outOfTime || editingRoot)
      .padding()
    }
    .onAppear {
      send(.appeared)
      focussingWord = true
    }
    .onChange(of: editingRoot) {
      if editingRoot {
        focussingRoot = true
      } else {
        focussingWord = true
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        if store.game.limit != nil, let countdown = store.countdown {
          Text(max(countdown, .zero), format: .units(maximumUnitCount: 1))
            .foregroundColor(store.outOfTime ? .red : .primary)
        } else {
          Button(.localizable(.timer), systemImage: "timer") { store.game.limit = .seconds(180) }
            .font(.title2)
            .disabled(store.outOfTime)
        }
      }

      ToolbarItem(placement: .principal) {
        Text(.localizable(.scoreLld(store.score)))
          .font(.headline)
      }

//      ToolbarItem(placement: .confirmationAction) {
//        Button(.localizable(.save), systemImage: "checkmark.seal") { send(.saveButtonTapped) }
//          .tint(.green)
//      }
    }
  }

  @FocusState var focussingWord: Bool
  @FocusState var focussingRoot: Bool
  @State var editingRoot = false

  public init(store: StoreOf<Singleplayer>) { self.store = store }
}

#Preview {
  NavigationStack {
    SingleplayerView(store: Store(
      initialState: Singleplayer.State(root: "universal", language: .init(identifier: "en"), limit: nil),
      reducer: Singleplayer.init
    ))
  }
}

#Preview("With timer") {
  NavigationStack {
    SingleplayerView(store: Store(
      initialState: Singleplayer.State(root: "universal", language: .init(identifier: "de"), limit: .seconds(180)),
      reducer: Singleplayer.init
    ))
  }
}

//  func addWord(_ word: String) {
//    do {
//      let newWord = try NewWord(word, game: self.game)
//      let foundWord = FoundWord(newWord)
//
//      game.foundWords.append(foundWord)
//    } catch let alert as NewAlert {
//      newAlerts.append(alert)
//    } catch {}
//  }
//
//  func startGame(_ word: String) {
//    do {
//      let settings = try getNewSettings(with: word)
//
//      start(settings)
//    } catch let alert as RootAlert {
//      rootAlert = alert
//    } catch {}
//  }
//
//  func timerAction() {
//    guard !game.timeUp else { return cancelTimer() }
//
//    increaseTimer()
//
//    alertAboutTimer()
//  }
//
//  func returnToSetup() {
//    saveGame()
//    setup()
//  }
//
//  func saveGame() { save(game) }
//
//  private func alertAboutTimer() {
//    if game.timer {
//      switch game.time {
//      case game.secondlimit / 2: timeAlert = TimeAlert(.half)
//      case game.secondlimit - 30: timeAlert = TimeAlert(.thirty)
//      case game.secondlimit: timeAlert = TimeAlert(.out)
//      default: break
//      }
//    }
//  }
