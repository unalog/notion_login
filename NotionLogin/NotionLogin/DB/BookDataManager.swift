//
//  BookDataManager.swift
//  MyNotion
//
//  Created by una on 2021/10/15.
//

import Foundation
import RealmSwift

class BookDataManager {
    static let share = BookDataManager()
    
    var seriesLastDate = Date(timeIntervalSince1970: 0)
    var writerLastDate = Date(timeIntervalSince1970: 0)
    var bookLastDate = Date(timeIntervalSince1970: 0)
    var purchaseLastDate = Date(timeIntervalSince1970: 0)
//
//    func update(writerList: [Writer], seriesList: [Series], bookList: [Book], purchaseList: [Purchase]) {
//        do {
//            let realm = try Realm(configuration: BookDataManager.realmConfiguration)
//            
//            try realm.write({
//                
//                let purchaseData = purchaseList.compactMap { purchase -> RealmPurchase? in
//                    var realmPurchase = realm.object(ofType: RealmPurchase.self, forPrimaryKey: purchase.id)
//                    
//                    if realmPurchase == nil {
//                        realmPurchase = RealmPurchase()
//                        realmPurchase?.id = purchase.id
//                    }
//                    
//                    realmPurchase?.title = purchase.title
//                    realmPurchase?.price = purchase.price
//                    realmPurchase?.realPrice = purchase.realPrice
//                    realmPurchase?.platform = purchase.platform
//                    realmPurchase?.date = purchase.date
//                    realmPurchase?.lastEditTime = purchase.lastEditedTime
//                    
//                    return realmPurchase
//                }
//                realm.add(purchaseData, update: .all)
//                
//                let bookData = bookList.compactMap { book -> RealmBook? in
//                    var realmBook = realm.object(ofType: RealmBook.self, forPrimaryKey: book.id)
//                    
//                    if realmBook == nil {
//                        realmBook = RealmBook()
//                        realmBook?.id = book.id
//                    }
//                    
//                    realmBook?.title = book.title
//                    realmBook?.starRating = book.starRating
//                    realmBook?.date = book.date
//                    realmBook?.lastEditTime = book.lastEditedTime
//                   
//                    realmBook?.purchase.removeAll()
//                    book.purchaseIds.forEach { id in
//                       
//                        if let purchase =  realm.object(ofType: RealmPurchase.self, forPrimaryKey: id) {
//                            realmBook?.purchase.append(purchase)
//                        }
//                    }
//                    return realmBook
//                }
//                realm.add(bookData, update: .all)
//                
//                let seriesData = seriesList.compactMap { series -> RealmSeries? in
//                    var realmSerise = realm.object(ofType: RealmSeries.self, forPrimaryKey: series.id)
//                    
//                    if realmSerise == nil {
//                        realmSerise = RealmSeries()
//                        realmSerise?.id = series.id
//                    }
//                    
//                    realmSerise?.title = series.title
//                    realmSerise?.tag = series.tag
//                    realmSerise?.type = series.type
//                    realmSerise?.lastEditTime = series.lastEditedTime
//
//                    realmSerise?.books.removeAll()
//                    series.booksids.forEach { id in
//                        if let book = realm.object(ofType: RealmBook.self, forPrimaryKey: id) {
//                            realmSerise?.books.append(book)
//                        }
//                    }
//                    
//                    return realmSerise
//                }
//                realm.add(seriesData, update: .all)
//                
//                let writerData = writerList.compactMap { writer -> RealmWriter? in
//                    var realmWriter = realm.object(ofType: RealmWriter.self, forPrimaryKey: writer.id)
//                    
//                    if realmWriter == nil {
//                        realmWriter = RealmWriter()
//                        realmWriter?.id = writer.id
//                    }
//                    
//                    realmWriter?.name = writer.name
//                    realmWriter?.lastEditTime = writer.lastEditedTime
//                    realmWriter?.series.removeAll()
//                    writer.seriesIds.forEach { id in
//                        if let series = realm.object(ofType: RealmSeries.self, forPrimaryKey: id) {
//                            realmWriter?.series.append(series)
//                        }
//                    }
//                    return realmWriter
//                }
//                
//                realm.add(writerData, update: .all)
//            })
//            
//            
//        } catch let error  {
//            print(error.localizedDescription)
//        }
//    }
//
//    func getCoount() {
//
//        do {
//            let realm = try Realm(configuration: BookDataManager.realmConfiguration)
//            Observable.array(from: realm.objects(RealmWriter.self).sorted(byKeyPath: "lastEditTime", ascending: false))
//                .map{ $0.first }
//                .subscribe(onNext: { [weak self] writer in
//                    guard let self = self, let date = writer?.lastEditTime else { return }
//                    self.writerLastDate = date
//                })
//                .disposed(by: disposebag)
//
//            Observable.array(from: realm.objects(RealmSeries.self).sorted(byKeyPath: "lastEditTime", ascending: false))
//                .map{ $0.first }
//                .subscribe(onNext: { [weak self] series in
//                    guard let self = self, let date = series?.lastEditTime else { return }
//                    self.seriesLastDate = date
//                })
//                .disposed(by: disposebag)
//
//            Observable.array(from: realm.objects(RealmBook.self).sorted(byKeyPath: "lastEditTime", ascending: false))
//                .map{ $0.first }
//                .subscribe(onNext: { [weak self] book in
//                    guard let self = self, let date = book?.lastEditTime else { return }
//                    self.bookLastDate = date
//                })
//                .disposed(by: disposebag)
//
//            Observable.array(from: realm.objects(RealmPurchase.self).sorted(byKeyPath: "lastEditTime", ascending: false))
//                .map{ $0.first }
//                .subscribe(onNext: { [weak self] purchase in
//                    guard let self = self, let date = purchase?.lastEditTime else { return }
//                    self.purchaseLastDate = date
//                })
//                .disposed(by: disposebag)
//
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//
//    func seriesList() -> Observable<[Series]> {
//        do {
//            let realm = try Realm(configuration: BookDataManager.realmConfiguration)
//
//            return Observable.array(from: realm.objects(RealmSeries.self).sorted(by: [SortDescriptor(keyPath: "lastEditTime", ascending: false)]))
//                .map { results -> [Series] in
//                    return Array(results).compactMap { Series(realm: $0) }.sorted{ $0.editData > $1.editData }
//                }
//
//        } catch let error {
//            print(error.localizedDescription)
//            return Observable.error(NSError(domain: "db", code: 100, userInfo: nil))
//        }
//    }
//
//    func writerList() -> Observable<[Writer]> {
//        do {
//            let realm = try Realm(configuration: BookDataManager.realmConfiguration)
//
//            return Observable.array(from: realm.objects(RealmWriter.self).sorted(by: [SortDescriptor(keyPath: "lastEditTime", ascending: false)]))
//                .map { results -> [Writer] in
//                    return Array(results).compactMap { Writer(realm: $0) }.sorted{ $0.series?.count ?? 0 > $1.series?.count ?? 0 }
//                }
//
//        } catch let error {
//            print(error.localizedDescription)
//            return Observable.error(NSError(domain: "db", code: 100, userInfo: nil))
//        }
//
//    }
}
