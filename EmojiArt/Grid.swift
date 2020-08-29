//
//  Grid.swift
//  Memorize
//
//  Created by Ömer Ulusal on 7.08.2020.
//  Copyright © 2020 ulusalomer. All rights reserved.
//

import SwiftUI

extension Grid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \Item.id, viewForItem: viewForItem)
    }
}

struct Grid<Item, ID, ItemView>: View where ItemView: View, ID: Hashable {
    private var items: [Item]
    private var id: KeyPath<Item, ID>
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], id: KeyPath<Item, ID>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            forEach(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    func forEach(for layout: GridLayout) -> some View {
        ForEach(items, id: id) { item in
            itemView(for: item, in: layout)
        }
    }
    
    func itemView(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id] })
        return Group {
            if index != nil {
                viewForItem(item)
                .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                .position(layout.location(ofItemAt: index!))
            }
        }
    }
}
