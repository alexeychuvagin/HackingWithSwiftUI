//
//  AcquaintanceDetailsView.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 21.09.2021.
//

import SwiftUI
import CoreLocation

struct AcquaintanceDetailsView: View {
    @ObservedObject var vm: AcquaintanceDetailsViewModel
    
    init(vm: AcquaintanceDetailsViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Picker("StatePicker", selection: $vm.state.animation()) {
                Text("Details").tag(AcquaintanceDetailsViewModel.State.details)
                Text("Location").tag(AcquaintanceDetailsViewModel.State.location)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if vm.state == .details {
                Group {
                    vm.acquaintance.image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Text(vm.acquaintance.notes)
                }
                .transition(.move(edge: .leading))
            }
            else {
                Map(
                    centerCoordinate: .constant(vm.acquaintance.location ?? CLLocationCoordinate2D()),
                    showsUserLocation: .constant(false),
                    annotations: vm.annotations
                )
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                .padding(.horizontal)
                .transition(.move(edge: .trailing))
            }
            
            Spacer()
        }
        .navigationBarTitle(Text(vm.acquaintance.name))
    }
}

struct AcquaintanceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AcquaintanceDetailsView(vm: AcquaintanceDetailsViewModel(acquaintance: Acquaintance.stub_first))
        }
    }
}
