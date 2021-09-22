//
//  MapButton.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 20.09.2021.
//

import SwiftUI

struct MapButton: View {
    var image: Image
    var onClick: () -> Void
    
    var body: some View {
        Button(action: self.onClick) {
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
        MapButton(image: Image(systemName: "location"), onClick: { print("clicked") })
    }
}
