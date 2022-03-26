//
//  AssetsManager+Test.swift
//  CoinerTests
//
//  Created by Nikita Morozov on 3/26/22.
//

@testable import Coiner
import XCTest

class AssetsManagerTests: XCTestCase {
    
    var assetsStoreProtocolMock: AssetsStoreProtocolMock!
    var assetsManagerSubscriberProtocolMock: AssetsManagerSubscriberProtocolMock!
    var assetsManager: AssetsManager!
    
    override func setUp() {
        assetsStoreProtocolMock = AssetsStoreProtocolMock()
        assetsManagerSubscriberProtocolMock = AssetsManagerSubscriberProtocolMock()
        assetsManager = AssetsManager(assetsStore: assetsStoreProtocolMock)
    }
    
    override func tearDown() {
        assetsManager.unsubscribe(assetsManagerSubscriberProtocolMock)
    }
    
    func test_addToWatchlist_notify() throws {
        // given
        assetsManager.subscribe(assetsManagerSubscriberProtocolMock)
        let asset = makeAsset()
        
        // when
        assetsManager.addToWatchlist(asset: asset)
        
        // then
        XCTAssertEqual(1, assetsManagerSubscriberProtocolMock.assetDidAddToWatchlistCallCount)
        XCTAssertEqual(1, assetsStoreProtocolMock.addCallCount)
    }
    
    func test_removeFromWatchlist_notify() throws {
        // given
        assetsManager.subscribe(assetsManagerSubscriberProtocolMock)
        let asset = makeAsset()
        
        // when
        assetsManager.removeFromWatchlist(asset: asset)
        
        // then
        XCTAssertEqual(1, assetsManagerSubscriberProtocolMock.assetDidRemoveFromWatchlistCallCount)
        XCTAssertEqual(1, assetsStoreProtocolMock.removeCallCount)
    }
    
    func test_getWatchedAssets() throws {
        // given
        let assets = makeAssets()
        assetsStoreProtocolMock.getHandler = {
            assets
        }
        
        // when
        let result = assetsManager.getWatchedAssets()
        
        // then
        XCTAssertEqual(1, assetsStoreProtocolMock.getCallCount)
        XCTAssertEqual(assets.count, result.count)
    }
    
    func test_isInWatchlist_positive() throws {
        // given
        let assets = makeAssets()
        assetsStoreProtocolMock.getHandler = {
            assets
        }
        
        // when
        let result = assetsManager.isInWatchlist(asset: assets[1])
        
        // then
        XCTAssertEqual(1, assetsStoreProtocolMock.getCallCount)
        XCTAssertTrue(result)
    }
    
    func test_isInWatchlist_negative() throws {
        // given
        let assets = makeAssets()
        assetsStoreProtocolMock.getHandler = {
            Array(assets[0...1])
        }
        
        // when
        let result = assetsManager.isInWatchlist(asset: assets[2])
        
        // then
        XCTAssertEqual(1, assetsStoreProtocolMock.getCallCount)
        XCTAssertFalse(result)
    }
    
    func test_subscribe() throws {
        // given
        let asset = makeAsset()
        
        // when
        assetsManager.subscribe(assetsManagerSubscriberProtocolMock)
        assetsManager.addToWatchlist(asset: asset)
        
        // then
        XCTAssertEqual(1, assetsManagerSubscriberProtocolMock.assetDidAddToWatchlistCallCount)
    }
    
    func test_unsubscribe() throws {
        // given
        let asset = makeAsset()
        assetsManager.subscribe(assetsManagerSubscriberProtocolMock)
        
        // when
        assetsManager.unsubscribe(assetsManagerSubscriberProtocolMock)
        assetsManager.addToWatchlist(asset: asset)
        
        // then
        XCTAssertEqual(0, assetsManagerSubscriberProtocolMock.assetDidAddToWatchlistCallCount)
    }
}

extension AssetsManagerTests {
    
    private func makeAsset() -> AssetEntity {
        AssetEntity(id: "1", symbol: "BTC", name: "Bitcoin", price: 1000000, marketCap: 1000000, changePercentage: 3.2, volume24Hr: 1000, supply: 1222222)
    }
    
    private func makeAssets() -> [AssetEntity] {
        [
            AssetEntity(id: "1", symbol: "BTC", name: "Bitcoin", price: 1000000, marketCap: 1000000, changePercentage: 3.2, volume24Hr: 1000, supply: 1222222),
            AssetEntity(id: "2", symbol: "ETH", name: "Ethereum", price: 100, marketCap: 1050, changePercentage: -0.2, volume24Hr: 2000, supply: 11111),
            AssetEntity(id: "3", symbol: "SHIB", name: "Shiba Inu", price: 0.00025, marketCap: 50000, changePercentage: 14.2, volume24Hr: 50000, supply: 333333),
        ]
    }
}
