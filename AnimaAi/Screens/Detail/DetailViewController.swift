import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var animeImageView: UIImageView!
    
    @IBOutlet weak var animeTitle: UILabel!
    @IBOutlet weak var animeDescription: UILabel!
    @IBOutlet weak var animeRomanji: UILabel!
    @IBOutlet weak var animeJapones: UILabel!
    @IBOutlet weak var animeSinonimos: UILabel!
    @IBOutlet weak var animeTipos: UILabel!
    @IBOutlet weak var animeStatus: UILabel!
    @IBOutlet weak var animeEpisodios: UILabel!
    @IBOutlet weak var animeDetalhesStackView: UIStackView!
    var anime: Anime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animeImageView.layer.cornerRadius = 8
        animeImageView.layer.masksToBounds = true
        animeImageView.contentMode = .scaleAspectFill
        animeImageView.backgroundColor = .none
        
        animeDetalhesStackView.layer.cornerRadius = 8
        animeDetalhesStackView.layer.masksToBounds = true
        
        configure(with: anime)
    }

    func configure(with anime: Anime) {
        animeTitle.text = anime.attributes.canonicalTitle
        animeDescription.text = anime.attributes.description
        animeRomanji.text = anime.attributes.titles?.enJp ?? " - "
        animeJapones.text = anime.attributes.titles?.jaJp ?? " - "
        animeSinonimos.text = anime.attributes.abbreviatedTitles.filter{ $0 != nil }.map{ $0! }.joined(separator: ", ")
        animeTipos.text = anime.attributes.showType
        animeStatus.text = anime.attributes.status?.capitalized ?? " - "
        animeEpisodios.text = (String(describing: anime.attributes.episodeCount ?? 0))
        animeImageView.download(from: anime.attributes.posterImage?.large ?? "https://ih1.redbubble.net/image.4870404907.6541/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg")
    }
}
