import Foundation

class BrukerInnstillingerManager {
    static let standard = BrukerInnstillingerManager()
    
    private let delingstillatelseNøkkel = "delingstillatelse"

    enum Delingstillatelse: String {
        case kunLesing = "Kun lesing"
        case lesOgSkriv = "Les og skriv"
        case privat = "Privat"
    }

    func settDelingstillatelse(_ tillatelse: Delingstillatelse) {
        UserDefaults.standard.set(tillatelse.rawValue, forKey: delingstillatelseNøkkel)
    }

    func hentDelingstillatelse() -> Delingstillatelse {
        let verdi = UserDefaults.standard.string(forKey: delingstillatelseNøkkel) ?? Delingstillatelse.kunLesing.rawValue
        return Delingstillatelse(rawValue: verdi) ?? .kunLesing
    }
}
