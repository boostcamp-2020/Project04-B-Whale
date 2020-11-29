//
//  CalendarPickerViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import Foundation

protocol CalendarPickerViewModelProtocol {
  
  func bindingInitializeDate(handler: @escaping ([Day], Date) -> Void)
  func bindingUpdateCalendar(handler: @escaping ([Day], Date) -> Void)
  func bindingSendSelectedDate(handler: @escaping (String) -> Void)
  
  func fetchInitialCalendar()
  func fetchUpdatedCalendar(to months: Int)
  func updateSelectedDate(to date: Date)
  func sendSelectedDate()
}

final class CalendarPickerViewModel: CalendarPickerViewModelProtocol {
  
  // MARK: - Property
  
  private var initializeCalendarHandler: (([Day], Date) -> Void)?
  private var updateCalendarHandler: (([Day], Date) -> Void)?
  private var sendSelectedDateHandler: ((String) -> Void)?
  
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
  
  func bindingUpdateCalendar(handler: @escaping ([Day], Date) -> Void) {
    updateCalendarHandler = handler
  }
  
  func bindingSendSelectedDate(handler: @escaping (String) -> Void) {
    sendSelectedDateHandler = handler
  }
  
  func fetchInitialCalendar() {
    let days = daysInMonth(for: selectedDate)
    initializeCalendarHandler?(days, selectedDate)
  }
  
  func fetchUpdatedCalendar(to months: Int) {
    basedate = (self.calendar.date(
      byAdding: .month,
      value: months,
      to: basedate
    )) ?? basedate
    
    let days = daysInMonth(for: basedate)
    updateCalendarHandler?(days, basedate)
  }
  
  func updateSelectedDate(to date: Date) {
    selectedDate = date
    
    let days = daysInMonth(for: date)
    updateCalendarHandler?(days, selectedDate)
  }
  
  func sendSelectedDate() {
    let date = selectedDate.toString()
    sendSelectedDateHandler?(date)
  }
  
  
  // MARK: Calendar 계산
  
  private func daysInMonth(for baseDate: Date) -> [Day] {
    guard let monthMetadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }
    
    var days = makeDays(using: monthMetadata) // 이전 달 + 해당 달
    days += makeDaysOfNextMonth(using: days.count, monthMetadata.firstDay) // + 다음 달
    
    return days
  }
    
  private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
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
      firstDayIndex: firstDayWeekday)
  }
  
  private func makeDay(
    offsetBy dayOffset: Int,
    for baseDate: Date,
    isWithinDisplayedMonth: Bool
  ) -> Day {
    let date = calendar.date(
      byAdding: .day,
      value: dayOffset,
      to: baseDate) ?? baseDate
    
    return Day(
      date: date,
      number: dateFormatter.string(from: date),
      isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
      isWithinDisplayedMonth: isWithinDisplayedMonth
    )
  }
  
  private func makeDays(using monthMetadata: MonthMetadata) -> [Day] {
    let numberOfDaysInMonth = monthMetadata.numberOfDays        // 한 달의 일 수
    let firstDayOfMonth = monthMetadata.firstDay                // 해당 달의 첫 번째 날
    let firstDayOfMonthIndex = monthMetadata.firstDayIndex      // 해당 달의 첫 번째 날의 인덱스
    
    let days: [Day] = (1..<(numberOfDaysInMonth + firstDayOfMonthIndex)).map
    {
      day in
      
      let isWithinDisplayedMonth = day >= firstDayOfMonthIndex
      
      let dayOffset =
        isWithinDisplayedMonth ?
        day - firstDayOfMonthIndex :
        -(firstDayOfMonthIndex - day)
      
      return makeDay(
        offsetBy: dayOffset,
        for: firstDayOfMonth,
        isWithinDisplayedMonth: isWithinDisplayedMonth)
    }
    return days
  }
  
  private func makeDaysOfNextMonth(
    using counts: Int, _ firstDayOfDisplayedMonth: Date
  ) -> [Day] {
    guard let lastDayInMonth = calendar.date(
      byAdding: DateComponents(month: 1, day: -1),
      to: firstDayOfDisplayedMonth
    ) else { return [] }
    
    let additionalDays = 42 - counts
    guard additionalDays > 0 else { return [] }
    
    let days = (1...additionalDays).map {
      return makeDay(
        offsetBy: $0,
        for: lastDayInMonth,
        isWithinDisplayedMonth: false)
    }
    return days
  }
  
  private enum CalendarDataError: Error {
    case metadataGeneration
  }
}
