//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Ömer Ulusal on 16.08.2020.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
            }
        }
    }
}
