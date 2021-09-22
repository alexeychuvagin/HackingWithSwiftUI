//
//  AcquaintanceRowView.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 17.09.2021.
//

import SwiftUI

struct AcquaintanceRow: View {
    private var acquaintance: Acquaintance
    
    init(for acquaintance: Acquaintance) {
        self.acquaintance = acquaintance
    }
    
    var body: some View {
        HStack {
            acquaintance.image
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Text(acquaintance.name)
                .font(.headline)
        }
    }
}

struct AcquaintanceRow_Previews: PreviewProvider {
    static var previews: some View {
        AcquaintanceRow(for: Acquaintance.stub_first)
    }
}
