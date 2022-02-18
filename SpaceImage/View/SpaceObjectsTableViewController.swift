//
//  SpaceObjectsTableViewController.swift
//  SpaceImage
//
//  Created by Михаил Иванов on 18.02.2022.
//

import UIKit

class SpaceObjectsTableViewController: UITableViewController {
    var objectsSpace: [SpaceLoadObject] = []

    private let context = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        objectsSpace = context.fetchData()
        getAPODs()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objectsSpace.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpaceObjectCell
        let objectSpace = objectsSpace[indexPath.row]
        cell.configure(with: objectSpace)
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let infoSOVC = segue.destination as? InfoSpaceObjectViewController else { return }
        guard let index = tableView.indexPathForSelectedRow else {
            return
        }

        infoSOVC.spaceObject = objectsSpace[index.row]
    }
}

// MARK: - API connect

extension SpaceObjectsTableViewController {
//    private func getAPODs() {
//        NasaAPI.shared.getSpaceObjects(url: .apod) { result in
//            switch result {
//                case .success(let result):
//                    self.objectsSpace = result as! [SpaceLoadObject]
//                    self.tableView.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription)
//            }
//        }
//    }

    private func getAPODs() {
        NasaAPI.shared.getSpaceObjects(url: .apod) { [unowned self] result in
            switch result {
                case .success(let result):
                    guard let resultLoads = result as? [SpaceObject] else { return }
                    for resultLoad in resultLoads {
                        context.saveSpace(resultLoad) { spaceLoadObject in
                            self.objectsSpace.append(spaceLoadObject)
                        }
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    private func checkLoadImage() {
        if objectsSpace.count < 1 {
            getAPODs()
        }
    }
}
