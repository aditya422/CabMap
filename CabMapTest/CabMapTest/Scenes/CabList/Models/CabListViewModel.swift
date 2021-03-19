struct CabListViewModel: Equatable {
    let headerTitle: String?
    let mapButtonTitle: String?
    
    init(headerTitle: String? = nil,
         mapButtonTitle: String? = nil) {
        self.headerTitle = headerTitle
        self.mapButtonTitle = mapButtonTitle
    }
}
