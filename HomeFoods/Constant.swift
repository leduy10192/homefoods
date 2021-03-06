struct K {
    static let restaurantLogSeg = "restaurantToHome"
    static let memberLogSeg = "memberToHome"
    static let mHomeToSearch = "mHometoSearch"
    static let cellNibName = "PostCell"
    static let cellIdentifier = "PostCell"
    static let RestaurantCell = "RestaurantCell"
    static let MhomeToMCart = "MhomeToMCart"
    static let cartCell = "CartCell"
    static let CartToOrderConfirm = "CartToOrderConfirm"
    static let OrderConfirmToHome = "OrderConfirmToHome"
    static let resHomeToSum = "resHomeToSum"
    static let memHomeToSum = "memHomeToSum"
    
    struct FStore {

        static let restaurant = "restaurant"
        static let member = "member"
        static let name = "name"
        static let email = "email"
        static let street = "street"
        static let city = "city"
        static let state = "state"
        static let zip = "zip"
        static let phoneNumber = "phoneNumber"
        static let userType = "userType"
        static let memberName = "memberName"
        static let memberPhoneNum = "memberPhoneNum"
        static let memberEmail = "memberEmail"
        static let tags = "tags"
        static let description = "description"
        static let kitchenDays = "kitchenDays"
        static let additionalInfo = "additionalInfo"
        
        static let items = "items"
        static let orders = "orders"
        static let itemName = "name"
        static let unit = "unit"
        static let quantity = "quantity"
        static let price = "price"
        static let isAvail = "isAvail"
        static let avail = "avail"
        static let imagesFolder = "imagesFolder"
        static let imagesCollection = "imagesCollection"
        static let uid = "uid"
        static let imageUrl = "imageUrl"
        static let date = "date"
        static let orderDate = "orderDate"
        static let pickupDate = "pickupDate"
        static let resName = "resName"
        static let resEmail = "resEmail"
        static let resAddress = "resAddress"
        static let resPhone = "resPhone"
        static let cart = "cart"
        static let memberOrders = "memberOrders"
        static let lastUpdated = "lastUpdated"
        static let lat = "lat"
        static let lon = "lon"
    }
    
    struct Chat {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "MessageCell"
        static let registerSegue = "RegisterToChat"
        static let loginSegue = "LoginToChat"
        
        struct BrandColors {
            static let purple = "BrandPurple"
            static let lightPurple = "BrandLightPurple"
            static let blue = "BrandBlue"
            static let lightBlue = "BrandLightBlue"
        }
        
        struct FStore {
            static let collectionName = "messages"
            static let senderField = "sender"
            static let bodyField = "body"
            static let dateField = "date"
        }
    }
}

