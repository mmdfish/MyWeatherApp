//
//  GridStack.swift
//  MyWeatherApp
//
//  Created by fish on 2021/6/17.
//


import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing:15, content: {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack (spacing:16, content: {
                    ForEach(0 ..< columns, id: \.self) { column in
                        content(row, column)
                    }
                })
            }
        })
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            Image(systemName: "\(row * 4 + col).circle")
            Text("R\(row) C\(col)")
        }
    }
}
