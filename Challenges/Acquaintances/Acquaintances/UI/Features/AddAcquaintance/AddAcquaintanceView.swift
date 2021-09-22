//
//  AddAcquaintanceView.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 17.09.2021.
//

import SwiftUI
import Resolver
import Combine
import CoreLocation

struct AddAcquaintanceView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: AddAcquaintanceViewModel
    
    var body: some View {
        VStack {
            vm.image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                .padding()
            
            HStack {
                NavigationLink(destination: AddAcquaintanceMapView(currentLocation: $vm.location)) {
                    Text(vm.location == nil ? "Add location" : "Location added")
                    Image(systemName: vm.location == nil ? "location.slash" : "location")
                }
                .foregroundColor(vm.location == nil ? .blue : .green)
            }
            
            Form {
                Section(header: Text("Who is this?")) {
                    TextField("Full Name", text: $vm.name)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $vm.notes)
                        .frame(minHeight: 100)
                }
            }
        }
        .navigationTitle("Add acquaintance")
        .navigationBarTitleDisplayMode(.inline)
        .if(colorScheme == .light) { view in
            view.background(Color(UIColor.systemGray6))
        }
        .navigationBarItems(
            leading:
                Button("Close") {
                    self.presentationMode.wrappedValue.dismiss()
                },
            trailing:
                Button("Save") {
                    self.vm.save()
                    self.presentationMode.wrappedValue.dismiss()
                }
                .disabled(vm.name.isEmpty)
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct AcquaintanceDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddAcquaintanceView(vm: AddAcquaintanceViewModel(image: Image("profile-test")))
        }
    }
}
