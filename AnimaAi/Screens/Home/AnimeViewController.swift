
import Combine
import UIKit

class AnimeViewController: UICollectionViewController{
      private var viewModel = AnimeViewModel()
      private var subscriptions = Set<AnyCancellable>()
      private var dataSource: UICollectionViewDiffableDataSource<Section, Anime>?
      
      enum Section: Int, CaseIterable {
          case main
      }
    
    /// Função responsavel por atualizar e resetar os animes da minha tela e jogar meu scroll para o topo
    private func refresh(){
        self.viewModel.fetchAnimesData(page: 1)
        collectionView.setContentOffset(CGPoint(x:0,y:-100	), animated: true)
    }
    
    /// Função responsavel por atualizar e resetar os animes da minha tela
    @objc func refreshFunc(_ sender: Any) {
        self.viewModel.fetchAnimesData(page: 1)
    }
    
    
    /// Funções a seguir são para criar um botão para ordenação
    lazy var popularidade = UIAction(title: "Popularidade") { action in
        self.viewModel.sort = "-user_count"
        self.refresh()
    }
    /// Funções a seguir são para criar um botão para ordenação
    lazy var classificacao = UIAction(title: "Classificação Média") { action in
        
        self.viewModel.sort = "-average_rating"
        self.refresh()
    }
    /// Funções a seguir são para criar um botão para ordenação
    lazy var data = UIAction(title: "Data") { action in
        
            self.viewModel.sort =  "-start_date"
        self.refresh()
    }
    /// Funções a seguir são para criar um botão para ordenação
    lazy var adicionadosRecentemente = UIAction(title: "Adicionados recentemente") { action in
        
            self.viewModel.sort = "-created_at"
        self.refresh()
    }
    /// Funções a seguir são para criar um botão para ordenação
    lazy var elements = [adicionadosRecentemente, data,classificacao,  popularidade]
    
    /// Funções a seguir são para criar um botão para ordenação
    lazy var menu = UIMenu(children: elements)
    
    /// Funções a seguir são para criar um botão para ordenação
    lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ordenar", for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
        button.backgroundColor = UIColor(red: 0.49, green: 0.49, blue: 0.51, alpha: 1.00)
        button.layer.cornerRadius = 8
        return button
    }()
    /// Funções a seguir são para criar um botão para ordenação
    private func addConstrainsButton(){
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 46, leading: 20, bottom: 0, trailing: 20)
    }
    /// Funções a seguir são para criar um alerta na tela do usuário (quando tiver erro)
      lazy var alert: UIAlertController = {
          let alert =  UIAlertController(title: "Error!", message: "Ops, algo deu errado amigos.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

          return alert
      }()
    
    /// Funções a seguir são para criar um componente de refresh
      lazy var refreshControll: UIRefreshControl = {
          let refreshControll = UIRefreshControl()
          refreshControll.tintColor = .white
          refreshControll.addTarget(self, action: #selector(refreshFunc(_:)), for: .allEvents)
          
          return refreshControll
      }()
    
    
    /// Funções iniciar minha navigationBar com os estilos corretos
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(false)
           self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barStyle = .black
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       }
       
 
    /// Funções quando a tela inicia
    override func viewDidLoad() {
           super.viewDidLoad()
        addConstrainsButton()
        setLayout()
        setupDataSource()
    }


    /// Funções para deixar minah barra branca
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
    
    
    
    /// Função para criar toda as etapas do layout
        func setLayout() {
            collectionView.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView?.register(AnimeCell.self, forCellWithReuseIdentifier: "id")
             collectionView.isPrefetchingEnabled = true
             collectionView.showsVerticalScrollIndicator = false
             collectionView.delegate = self
             collectionView.prefetchDataSource = self
            
            view.addSubview(collectionView)
            self.collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            self.collectionView.refreshControl = refreshControll
            view.addSubview(button)
            
            button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32).isActive = true
            button.widthAnchor.constraint(equalToConstant: 86).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
          
        }
        
    
    
    func setupDataSource() {
            
        /// Responsavel por criar o layout da minha celula (cell)
           self.dataSource =
           UICollectionViewDiffableDataSource<Section, Anime>(collectionView: self.collectionView) {
               (collectionView, indexPath, source) -> UICollectionViewCell? in
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as? AnimeCell
               else { preconditionFailure() }
       
               let anime =  self.viewModel.animesData.value[indexPath.row]
               cell.setup(anime: anime)
               return cell
           }
           
            /// Responsavel por redesenhar a minha tela toda vez que chega um dado novo do scroll infinito
           self.viewModel.animesData
               .receive(on: DispatchQueue.main)
               .sink { [weak self] updatedData in
                   guard let self = self else { return }
                   
                   var snapshot = NSDiffableDataSourceSnapshot<Section, Anime>()
                   snapshot.appendSections([.main])
                   snapshot.appendItems(updatedData)
                   self.dataSource?.apply(snapshot, animatingDifferences: true)
               }
               .store(in: &subscriptions)
           
        
          /// Responsavel por desabilitar ou mostrar uma notificação de erro quando o status mudar
           self.viewModel.process
               .receive(on: DispatchQueue.main)
               .sink { [weak self] status in
                   guard let self = self else { return }

                   DispatchQueue.main.async {
                       switch status {
                       case .finished:
                           self.refreshControll.endRefreshing()
                       case let .failedWithError(error):
                           print(error)
                           self.present(self.alert, animated: true, completion: nil)
                           break
                       default:
                           break
                       }
                   }
               }
               .store(in: &subscriptions)
       }
    
    
    ///  Aqui é onde fica o clique do aplicaitvo
    override
    func collectionView(_ collectionView: UICollectionView,
             didSelectItemAt indexPath: IndexPath) {

        let anime =  self.viewModel.animesData.value[indexPath.row]
        let storyboard = UIStoryboard(name: "DetailScreen", bundle: Bundle(for: DetailViewController.self))
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.anime = anime
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}


/// Layout das celulas
extension AnimeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
    
        return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }

    
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width: widthPerItem - 8, height: 190)
    }
}


/// Escuta o scroll do CollectionView e quando ele chega em um certo valor e não está em processamento ele busca mais dados
extension AnimeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let row = indexPaths.first?.row else {
            return
        }
        
        let dataSources = self.viewModel.animesData.value
        
        
        if row > dataSources.count - 10 && self.viewModel.process.value != .inProcess  {
            DispatchQueue.main.async {
                let loadedPage = self.viewModel.loadedPage
                self.viewModel.fetchAnimesData(page: loadedPage + 1)
            }
        }
    }
}
