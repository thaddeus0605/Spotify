//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/27/23.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    var playlists = [Playlist]()
    
    public var sectionHandler: ((Playlist) -> Void)?
    
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoPlaylistView()
        fetchPlaylistData()
        
        
        if sectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCancel))
        }
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
    }
    
    
    
    private func setUpNoPlaylistView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(
            with: ActionLabelViewViewModel(
                text: "You don't have any playlists!",
                actionTitle: "Create"
            )
        )
    }
    
    private func fetchPlaylistData() {
        APICaller.shared.getCurrentUserPlayists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            //show label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            //Show Playlits
            tableView.reloadData()
            tableView.isHidden = false
            noPlaylistsView.isHidden = true
        }
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter playlist name",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Playlist...."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        // refresh List of playlists
                        self?.fetchPlaylistData()
                    }
                    else {
                        print("failed to create playlist")
                    }
                }
            }
            
            
        }))
        
        present(alert, animated: true)
    }
}


extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}


extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
            title: playlist.name,
            subtitle: playlist.owner.display_name,
            imageURL: URL(string: playlist.images.first?.url ?? "")
        )
                       
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        
        guard sectionHandler == nil else {
            sectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlaylistViewController(playlist: playlist)
        HapticsManager.shared.vibrateForSelection()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOWner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
}
