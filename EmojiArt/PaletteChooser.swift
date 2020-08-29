//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Ömer Ulusal on 19.08.2020.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                chosenPalette = document.palette(after: chosenPalette)
            }, onDecrement: {
                chosenPalette = document.palette(before: chosenPalette)
            }, label: {
                EmptyView()
            })
            Text(document.paletteNames[chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                .sheet(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPaletteEditor)
                        .environmentObject(document)
                        .frame(minWidth: 300, minHeight: 500)
                }
        }.fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    @State var paletteName: String = ""
    @State var emojisToAdd: String = ""
    
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor")
                    .font(.headline)
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }, label: { Text("Done") })
                        .padding()
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                            if !began {
                                document.renamePalette(chosenPalette, to: paletteName)
                            }
                        })
                        .padding()
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                            if !began {
                                chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                                emojisToAdd = ""
                            }
                        })
                        .padding()
                }
                Section(header: Text("Remove Emoji")) {
                    Grid(chosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: fontSize))
                            .onTapGesture {
                                chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                            }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }.frame(height: height)
                }
            }
        }
        .onAppear { self.paletteName = document.paletteNames[chosenPalette] ?? "" }
    }
    
    //MARK: - Drawing Constants
    var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6) * 100 + 70
    }
    
    let fontSize: CGFloat = 40
}
