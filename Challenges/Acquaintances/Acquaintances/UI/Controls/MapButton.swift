//
//  MapButton.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 20.09.2021.
//

import SwiftUI

struct MapButton: View {
    var image: Image
    var onTap: () -> Void
    
    var body: some View {
        Button(action: self.onTap) {
            image
                .padding()
                .background(Color.black.opacity(0.75))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(Circle())
                .padding(.trailing)
        }
    }
}

struct MapButton_Previews: PreviewProvider {
    static var previews: some View {
        MapButton(image: Image(systemName: "location"), onTap: { print("tapped") })
    }
}
