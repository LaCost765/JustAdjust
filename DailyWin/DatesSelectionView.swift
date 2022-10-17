//
//  DatesSelectionView.swift
//  DailyWin
//
//  Created by Egor Baranov on 17.10.2022.
//

import SwiftUI

struct DatesSelectionView: View {
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var needEndDate = false
    @State private var selectedDateMode = 0
    
    private var isDatePickerEnabled: Bool {
        (selectedDateMode == 0) || needEndDate
    }
    
    private var endDateString: String {
        needEndDate ?
        endDate.getFormatted(dateStyle: .short, timeStyle: .none) :
        "Бессрочно"
    }
    
    private var startDateString: String {
        startDate.getFormatted(dateStyle: .short, timeStyle: .none)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Spacer()
                HStack(alignment: .bottom) {
                    Text("с")
                        .font(.title2)
                    Text(startDateString)
                        .foregroundColor(selectedDateMode == 0 ? .red : .primary)
                        .font(.title2.bold())
                    Text("по")
                        .font(.title2)
                    Text(endDateString)
                        .foregroundColor(selectedDateMode == 1 ? .red : .primary)
                        .font(.title2.bold())
                    Spacer()
                }
                .padding(.vertical)
                Spacer()
                
                DatePicker("", selection: selectedDateMode == 0 ? $startDate : $endDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .blur(radius: isDatePickerEnabled ? 0 : 10)
                    .allowsHitTesting(isDatePickerEnabled)
                    .environment(\.locale, Locale.init(identifier: "ru"))

                Text(needEndDate ? "Удалить" : "Выбрать")
                    .font(.headline)
                    .foregroundColor(needEndDate ? .red : .blue)
                    .onTapGesture {
                        withAnimation {
                            needEndDate.toggle()
                        }
                    }
                    .opacity(selectedDateMode == 0 ? 0 : 1)
                    .padding(.bottom)
                    .transition(.opacity)
                
                Picker("", selection: $selectedDateMode.animation()) {
                    Text("Дата начала").tag(0)
                    Text("Дата конца").tag(1)
                }
                .pickerStyle(.segmented)
            }
            .padding()
        }
        .navigationTitle("Выбрать даты")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Готово") { }
        }
    }
}

struct DatesSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatesSelectionView()
        }
    }
}
