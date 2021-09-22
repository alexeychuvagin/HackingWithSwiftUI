//
//  AcquaintancesListView.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 17.09.2021.
//

import SwiftUI

struct AcquaintancesListView: View {
    @ObservedObject var vm: AcquaintancesListViewModel
    
    var body: some View {
        List {
            ForEach(vm.acquaintances) { acquaintance in
                NavigationLink(destination: AcquaintanceDetailsView(vm: AcquaintanceDetailsViewModel(acquaintance: acquaintance))) {
                    AcquaintanceRow(for: acquaintance)
                }
            }
        }
        .navigationTitle("Acquaintances")
        .navigationBarItems(
            trailing: Button(action: { self.vm.showingImagePicker.toggle() }) {
                Image(systemName: "person.crop.circle.badge.plus")
            }
        )
        .sheet(
            isPresented: $vm.showingImagePicker,
            onDismiss: { self.vm.showingCreateAcquaintance = self.vm.image != nil },
            content: { ImagePicker(image: $vm.image) }
        )
        .sheet(
            isPresented: $vm.showingCreateAcquaintance,
            onDismiss: { vm.refresh() }
        ) {
            NavigationView {
                AddAcquaintanceView(vm: AddAcquaintanceViewModel(image: self.vm.image!))
            }
        }
        .onAppear {
            vm.refresh()
        }
    }
}

struct AcquaintancesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AcquaintancesListView(vm: AcquaintancesListViewModel())
        }
    }
}
