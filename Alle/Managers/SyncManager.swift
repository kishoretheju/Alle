//
//  SyncManager.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 02/10/23.
//

import Foundation
import RealmSwift

struct SyncStatus {
  var pendingCount: Int
  var consideredCount: Int
  var isUploading: Bool
}

class SyncManager {
  let databaseRepo: DatabaseRepository
  
  var pendingCount: Int = 0
  var consideredCount: Int = 0
  var isUploading: Bool = false
  
  @Published var status: SyncStatus = SyncStatus(pendingCount: 0, consideredCount: 0, isUploading: false)
  var mainTimer: Timer? = nil
  var images: Results<ImageEntity>? = nil
  
  init(databaseRepo: DatabaseRepository) {
    self.databaseRepo = databaseRepo
  }
  
  func uploadImages(_ images: Results<ImageEntity>) {
    self.images = images
    createMainTimer()
  }
  
  func createMainTimer() {
    mainTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
      self.pendingCount = self.images?.count ?? 0
      
      if let result = self.imagesForUpload(), result.count > 0 {
        self.consideredCount += result.count
        self.isUploading = true
        
        self.publishUploadStatus()
        
        self.simulateNetworkCall(forImages: result)
      }
      else if let unwrappedImages = self.images, unwrappedImages.count == 0 {
        // Done with uploading so invalidate timer.
        self.consideredCount = 0
        self.isUploading = false
        
        self.publishUploadStatus()
        
        self.invalidateMainTimer()
      }
    }
  }
  
  func publishUploadStatus() {
    status = SyncStatus(pendingCount: pendingCount,
                        consideredCount: consideredCount,
                        isUploading: isUploading)
  }
  
  func maxConsideredCount() -> Int {
    return 5
  }
  
  func imagesForUpload() -> Slice<Results<ImageEntity>>? {
    if pendingCount == 0 {
      return nil
    }
    
    guard consideredCount < maxConsideredCount() else {
      return nil
    }
    
    let diff = maxConsideredCount() - consideredCount
    return images!.prefix(diff)
  }
  
  func simulateNetworkCall(forImages images: Slice<Results<ImageEntity>>) {
    images.forEach { image in
      self.upload(image) { success in
        self.databaseRepo.updateUploadImageStatus(ofImage: image, toStatus: success)
        self.consideredCount -= 1
      }
    }
  }
  
  func upload(_ image: ImageEntity, withCompletion completion: @escaping (_ success: Bool) -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + randomNumberOfSeconds()) {
      completion(true)
    }
  }
  
  func randomNumberOfSeconds() -> Double {
    return [4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0].randomElement()!
  }
  
  func invalidateMainTimer() {
    if let _ = mainTimer {
      mainTimer!.invalidate()
    }
  }
  
  deinit {
    invalidateMainTimer()
  }
}
