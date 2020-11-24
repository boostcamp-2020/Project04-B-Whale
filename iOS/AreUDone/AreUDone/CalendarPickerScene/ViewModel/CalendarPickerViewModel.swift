//
//  CalendarPickerViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import Foundation

protocol CalendarPickerViewModelProtocol {
  
  func bindingInitialize(handler: @escaping ([Day], Date) -> Void)
  func bindingUpdate(handler: @escaping ([Day], Date) -> Void)
  func bindingChangeSelectedDate(handler: @escaping ([Day]) -> Void)
  
  
  func fetchInitialData()
  func fetchUpdateMonth(to months: Int)
  
  func changeSelectedDate(to date: Date)

}

final class CalendarPickerViewModel: CalendarPickerViewModelProtocol {
  
  private var initializeCalendarHandler: (([Day], Date) -> Void)?
  private var updateCalendarHandler: (([Day], Date) -> Void)?
  private var updateSelectedDayHandler: (([Day]) -> Void)?
  
  var selectedDate: Date!
  private lazy var basedate: Date! = selectedDate
  
  func bindingInitialize(handler: @escaping ([Day], Date) -> Void) {
    initializeCalendarHandler = handler
  }
  
  func bindingUpdate(handler: @escaping ([Day], Date) -> Void) {
    updateCalendarHandler = handler
  }
  
  func bindingChangeSelectedDate(handler: @escaping ([Day]) -> Void) {
    updateSelectedDayHandler = handler
  }
  
 
  
  
  func fetchInitialData() {
    
    let days = generateDaysInMonth(for: selectedDate)
    
    initializeCalendarHandler?(days, selectedDate)
  }
  
  func fetchUpdateMonth(to months: Int) {
    
    basedate = (self.calendar.date(
      byAdding: .month,
      value: months,
      to: self.basedate
    ))!
    
    let days = generateDaysInMonth(for: basedate)
    
    updateCalendarHandler?(days, basedate)
  }
  
  func changeSelectedDate(to date: Date) {
    selectedDate = date
    print("선택된 날짜", selectedDate)
    let days = generateDaysInMonth(for: date)
    print(days)
    updateSelectedDayHandler?(days)
  }

  
  
  private let calendar = Calendar(identifier: .gregorian)
  
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()
  
  
  
  
  
  // 1
  func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    // 2
    guard
      let numberOfDaysInMonth = calendar.range( // 1..<31
        of: .day,
        in: .month,
        for: baseDate)?.count,
      let firstDayOfMonth = calendar.date(
        from: calendar.dateComponents([.year, .month], from: baseDate))
    
    else {
      // 3
      throw CalendarDataError.metadataGeneration
    }
    
    
    // 4
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
    
    // 5
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }
  
  // 1
  func generateDaysInMonth(for baseDate: Date) -> [Day] {
    // 2
    guard let metadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }
    
    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay
    
    // 3
    var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
      .map { day in
        // 4
        let isWithinDisplayedMonth = day >= offsetInInitialRow
        // 5
        let dayOffset =
          isWithinDisplayedMonth ?
          day - offsetInInitialRow :
          -(offsetInInitialRow - day)
        
        // 6
        return generateDay(
          offsetBy: dayOffset,
          for: firstDayOfMonth,
          isWithinDisplayedMonth: isWithinDisplayedMonth)
      }
    
    days += generateStartOfNextMonth(using: firstDayOfMonth)
    return days
  }
  
  // 7
  func generateDay(
    offsetBy dayOffset: Int,
    for baseDate: Date,
    isWithinDisplayedMonth: Bool
  ) -> Day {
    let date = calendar.date(
      byAdding: .day,
      value: dayOffset,
      to: baseDate)
      ?? baseDate
    
    if calendar.isDate(date, inSameDayAs: selectedDate) == true {
      print(date, selectedDate)
    }
    let day = Day(
      date: date,
      number: dateFormatter.string(from: date),
      isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
      isWithinDisplayedMonth: isWithinDisplayedMonth
      )
    return day
    
  }
  
  // 1
  func generateStartOfNextMonth(
    using firstDayOfDisplayedMonth: Date
  ) -> [Day] {
    // 2
    guard
      let lastDayInMonth = calendar.date(
        byAdding: DateComponents(month: 1, day: -1),
        to: firstDayOfDisplayedMonth)
    else {
      return []
    }
    // 3
    
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    guard additionalDays > 0 else {
      return []
    }
    
    // 4
    let days: [Day] = (1...additionalDays)
      .map {
        
        return generateDay(
          offsetBy: $0,
          for: lastDayInMonth,
          isWithinDisplayedMonth: false)
      }
    return days
  }
  
  enum CalendarDataError: Error {
    case metadataGeneration
  }
  
  
}
