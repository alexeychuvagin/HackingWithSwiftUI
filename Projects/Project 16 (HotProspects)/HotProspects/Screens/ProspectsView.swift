//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Alexey Chuvagin on 28.09.2021.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum SortingMode {
    case name, recent
}

struct ProspectsView: View {
    @EnvironmentObject private var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSortSettings = false
    @State private var sortingMode = SortingMode.name
    
    let filter: FilterType
    
    private var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    private var sortedProspects: [Prospect] {
        switch sortingMode {
        case .name:
            return filteredProspects.sorted { $0.name < $1.name }
        case .recent:
            return filteredProspects.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack {
                        Image(systemName: prospect.isContacted
                              ? "person.crop.circle.badge.checkmark"
                              : "person.crop.circle.badge.xmark")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name).font(.headline)
                            Text(prospect.emailAddress).foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(filter.description)
            .navigationBarItems(
                leading: Button(action: { self.isShowingSortSettings = true }) {
                    Image(systemName: "arrow.up.arrow.down.square")
                    Text("Sort")
                },
                trailing: Button(action: { self.isShowingScanner = true }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                }
            )
            .actionSheet(isPresented: $isShowingSortSettings) {
                ActionSheet(title: Text("Sort people"), message: Text("Select the way users are sorted"), buttons: [
                    .default(Text("By name")) { self.sortingMode = .name },
                    .default(Text("By most recent")) { self.sortingMode = .recent },
                    .cancel()
                ])
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "Tim Cook\ntim.cook@swift.com",
                    completion: self.handleScan
                )
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            self.prospects.add(person)
        case .failure(_):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            // Notice that I’ve used UNCalendarNotificationTrigger for the trigger, which lets us specify a custom DateComponents instance. I set it to have an hour component of 9, which means it will trigger the next time 9am comes about.
            /*
             var dateComponents = DateComponents()
             dateComponents.hour = 9
             let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
             */
            
            // For testing purposes, I recommend you comment out that trigger code and replace it with the following, which shows the alert five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            }
            else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    }
                    else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects(repository: UserDefaultsProspectsRepository.shared))
    }
}
