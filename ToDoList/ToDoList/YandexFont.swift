import UIKit

enum YandexFont {
    case largeTitle
    case title
    case headline
    case body
    case subhead
    case footnote
}

extension YandexFont {
    var font: UIFont {
        var font: UIFont

        switch self {
        case .largeTitle:
            font = UIFont(
                name: "SFProDisplay-Regular",
                size: 38
            )?.withWeight(UIFont.Weight(rawValue: 700)) ?? .systemFont(ofSize: 38, weight: UIFont.Weight(rawValue: 700))
        case .title:
            font = UIFont(
                name: "SFProDisplay-Regular",
                size: 20
            )?.withWeight(UIFont.Weight(600)) ?? .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 600))
        case .headline:
            font = UIFont(
                name: "SFProText-Regular",
                size: 17
            )?.withWeight(UIFont.Weight(600)) ?? .systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 600))
        case .body:
            font = UIFont(
                name: "SFProText-Regular",
                size: 17
            )?.withWeight(UIFont.Weight(400)) ?? .systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 400))
        case .subhead:
            font = UIFont(
                name: "SFProText-Regular",
                size: 15
            )?.withWeight(UIFont.Weight(400)) ?? .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 400))
        case .footnote:
            font = UIFont(
                name: "SFProText-Regular",
                size: 13
            )?.withWeight(UIFont.Weight(600)) ?? .systemFont(ofSize: 13, weight: UIFont.Weight(rawValue: 600))
        }
        
        return font
    }
}
