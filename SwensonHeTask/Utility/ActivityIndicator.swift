//
//  ActivityIndicator.swift
//  SwensonHeTask
//
//  Created by Mohamed Anwar on 4/16/21.

import Foundation
import RxSwift
import RxCocoa

typealias ActivityIndicatorState = (isLoading: Bool, isUserInteractionEnabled: Bool)

class ActivityIndicatorTracker: SharedSequenceConvertibleType {
    typealias Element = ActivityIndicatorState
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _behavior = BehaviorRelay<ActivityIndicatorState>(value: (false, false))
    private let _loading: SharedSequence<SharingStrategy, ActivityIndicatorState>
    
    public init() {
        _loading = _behavior
                        .asDriver()
                        .distinctUntilChanged { lhs, rhs in
                            return lhs.isLoading == rhs.isLoading
                        }
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O, isUserInteractionEnabled: Bool) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: {
                self.subscribed(isUserInteractionEnabled: isUserInteractionEnabled)
            })
    }
    
    private func subscribed(isUserInteractionEnabled: Bool) {
        _lock.lock()
        _behavior.accept((isLoading: true, isUserInteractionEnabled: isUserInteractionEnabled))
        _lock.unlock()
    }
    
    private func sendStopLoading() {
        _lock.lock()
        _behavior.accept((isLoading: false, isUserInteractionEnabled: false))
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableConvertibleType {
    func trackActivity(on activityIndicator: ActivityIndicatorTracker, isUserInteractionEnabled: Bool) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self, isUserInteractionEnabled: isUserInteractionEnabled)
    }
}
