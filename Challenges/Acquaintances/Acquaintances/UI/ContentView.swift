//
//  ContentView.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 17.09.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            AcquaintancesListView(vm: AcquaintancesListViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
