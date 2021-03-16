struct MapViewModel {
    let headerTitle: String?
    let annotations: [MapAnnotationModel]
    
    init(headerTitle: String? = nil,
         annotations: [MapAnnotationModel]) {
        self.headerTitle = headerTitle
        self.annotations = annotations
    }
}
