//
//  CalendarPickerViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import Foundation

protocol CalendarPickerViewModelProtocol {
  
  func bindingInitializeDate(handler: @escaping ([Day], Date) -> Void)
  func bindingUpdateDate(handler: @escaping ([Day], Date) -> Void)
  func bindingChangeSelectedDate(handler: @escaping ([Day]) -> Void)
  
  func fetchInitialData()
  func fetchUpdatedMonth(to months: Int)
  func changeSelectedDate(to date: Date)
}

final class CalendarPickerViewModel: CalendarPickerViewModelProtocol {
  
  // MARK: - Property
  
  private var initializeCalendarHandler: (([Day], Date) -> Void)?
  private var updateCalendarHandler: (([Day], Date) -> Void)?
  private var updateSelectedDayHandler: (([Day]) -> Void)?
  
  var selectedDate: Date!
  private lazy var basedate: Date! = selectedDate
  
  private let calendar = Calendar(identifier: .gregorian)
  
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()
  
  
  // MARK: - Method
  
  func bindingInitializeDate(handler: @escaping ([Day], Date) -> Void) {
    initializeCalendarHandler = handler
  }
  
  func bindingUpdateDate(handler: @escaping ([Day], Date) -> Void) {
    updateCalendarHandler = handler
  }
  
  func bindingChangeSelectedDate(handler: @escaping ([Day]) -> Void) {
    updateSelectedDayHandler = handler
  }
  
  func fetchInitialData() {
    let days = generateDaysInMonth(for: selectedDate)
    initializeCalendarHandler?(days, selectedDate)
  }
  
  func fetchUpdatedMonth(to months: Int) {
    basedate = (self.calendar.date(
      byAdding: .month,
      value: months,
      to: basedate
    )) ?? basedate
    
    let days = generateDaysInMonth(for: basedate)
    updateCalendarHandler?(days, basedate)
  }
  
  func changeSelectedDate(to date: Date) {
    selectedDate = date
    
    let days = generateDaysInMonth(for: date)
    updateSelectedDayHandler?(days)
  }
  
  
  // MARK: Calendar 계산 Method
  
  func generateDaysInMonth(for baseDate: Date) -> [Day] {
    guard let metadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }
    
    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay
    
    var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map
    { day in
      
      let isWithinDisplayedMonth = day >= offsetInInitialRow
      
      let dayOffset =
        isWithinDisplayedMonth ?
        day - offsetInInitialRow :
        -(offsetInInitialRow - day)
      
      return generateDay(
        offsetBy: dayOffset,
        for: firstDayOfMonth,
        isWithinDisplayedMonth: isWithinDisplayedMonth)
    }
    
    days += generateStartOfNextMonth(using: firstDayOfMonth)
    return days
  }
  
  func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    guard let numberOfDaysInMonth = calendar.range(
      of: .day,
      in: .month,
      for: baseDate
    )?.count,
    let firstDayOfMonth = calendar.date(
      from: calendar.dateComponents([.year, .month], from: baseDate))
    else {
      throw CalendarDataError.metadataGeneration
    }
    
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
    
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }
  
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
    
    let day = Day(
      date: date,
      number: dateFormatter.string(from: date),
      isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
      isWithinDisplayedMonth: isWithinDisplayedMonth
    )
    return day
  }
  
  func generateStartOfNextMonth(
    using firstDayOfDisplayedMonth: Date
  ) -> [Day] {
    guard let lastDayInMonth = calendar.date(
      byAdding: DateComponents(month: 1, day: -1),
      to: firstDayOfDisplayedMonth
    ) else { return [] }
    
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    guard additionalDays > 0 else { return [] }
    
    let days = (1...additionalDays).map {
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
