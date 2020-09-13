import StoreKit

class AppStoreReviewManager {
    static func requestReviewIfAppropriate() {
        if #available(iOS 10.3, *) {
            let defaults = UserDefaults.standard
            let numAppLaunches = defaults.integer(forKey: "numAppLaunches")
            if (numAppLaunches >= 3 && numAppLaunches % 3 == 0) {
                print("requestReview")
                SKStoreReviewController.requestReview()
            } else {
                print("dont requestReview")
            }
        }
    }
}

