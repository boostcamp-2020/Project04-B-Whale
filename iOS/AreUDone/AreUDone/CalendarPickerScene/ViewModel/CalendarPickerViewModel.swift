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
  
  func prepareForCardCount(with day: Int, completionHandler: ((Int) -> Void))
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
  private let cardService: CardServiceProtocol
  private var countDictionary = [String: Int]()
  
  private let calendar = Calendar(identifier: .gregorian)
  
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()
  
  
  // MARK:- Initializer
  
  init(cardService: CardServiceProtocol) {
    self.cardService = cardService
  }
  
  
  // MARK: - Method
  
  func fetchInitialCalendar() {
    let days = daysInMonth(for: selectedDate)
    fetchCardCount {
      self.initializeCalendarHandler?(days, self.selectedDate)
    }
  }
  
  func fetchUpdatedCalendar(to months: Int) {
    basedate = (calendar.date(
      byAdding: .month,
      value: months,
      to: basedate
    )) ?? basedate
    
    let days = daysInMonth(for: basedate)
    fetchCardCount {
      self.updateCalendarHandler?(days, self.basedate)
    }
  }
  
  func updateSelectedDate(to date: Date) {
    selectedDate = date
    
    let days = daysInMonth(for: date)
    updateCalendarHandler?(days, selectedDate)
  }
  
  func sendSelectedDate() {
    let date = selectedDate.toStringWithTime()
    sendSelectedDateHandler?(date)
  }
  
  func prepareForCardCount(with day: Int, completionHandler: ((Int) -> Void)) {
    let count = countDictionary["\(day)"] ?? 0
    completionHandler(count)
  }
  
  private func fetchCardCount(completionHandler: @escaping (() -> Void)) {
    guard
      let startDateAsString = basedate.startOfMonth()?.toString(),
      let endDateAsString = basedate.endOfMonth()?.toString()
    else { return }
    
    cardService.fetchCardsCount(
      startDate: startDateAsString,
      endDate: endDateAsString
    ) { [weak self] result in
      switch result {
      case .success(let monthCardCount):
        self?.countDictionary = .init()
        
        monthCardCount.cardCounts.forEach { dailyCard in
          guard
            let day = self?.dateFormatter.string(from: dailyCard.dueDate.toDateFormat(withDividerFormat: .dash))
          else { return }
          
          self?.countDictionary[day] = dailyCard.count
        }
        
        completionHandler()
        
      case .failure(let error):
        print(error)
      }
    }
  }
}


// MARK:- Extension bindUI

extension CalendarPickerViewModel {
  
  func bindingInitializeDate(handler: @escaping ([Day], Date) -> Void) {
    initializeCalendarHandler = handler
  }
  
  func bindingUpdateCalendar(handler: @escaping ([Day], Date) -> Void) {
    updateCalendarHandler = handler
  }
  
  func bindingSendSelectedDate(handler: @escaping (String) -> Void) {
    sendSelectedDateHandler = handler
  }
}

// MARK: Calendar 계산

private extension CalendarPickerViewModel {
  
  func daysInMonth(for baseDate: Date) -> [Day] {
    guard let monthMetadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }
    
    var days = makeDays(using: monthMetadata) // 이전 달 + 해당 달
    days += makeDaysOfNextMonth(using: days.count, monthMetadata.firstDay) // + 다음 달
    
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
      firstDayIndex: firstDayWeekday)
  }
  
  func makeDay(
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
  
  func makeDays(using monthMetadata: MonthMetadata) -> [Day] {
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
  
  func makeDaysOfNextMonth(
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
  
  enum CalendarDataError: Error {
    case metadataGeneration
  }
}
