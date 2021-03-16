// NOTE: - Currrently getting cab type as taxi in the response.  More cases can be added to the enum.
enum CabType: String {
    case taxi = "TAXI"
    // NOTE: - API never return any other vehicle type than taxi.  I am assuming it might return Moped just for
    // a sec of some other value.
    case moped = "MOPED"
}
