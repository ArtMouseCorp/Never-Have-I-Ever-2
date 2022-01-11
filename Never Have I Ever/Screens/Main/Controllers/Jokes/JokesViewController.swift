import UIKit

class JokesViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Table Views
    @IBOutlet weak var tableView: UITableView!
        
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.configure(tableView)
        print(Joke.all)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension JokesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Joke.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.jokes.id, for: indexPath) as! JokesTableViewCell
        let joke = Joke.all[indexPath.row]
        cell.initialize(title: joke.title, image: UIImage(named: joke.image))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let joke = Joke.all[indexPath.row]
        let jokeVC = JokeViewController.load(from: Main.joke)
        jokeVC.image = UIImage(named: joke.image)!
        jokeVC.jokeTitle = joke.title
        jokeVC.joke = joke.text
        self.navigationController?.pushViewController(jokeVC, animated: true)
    }
}

/*
 //           _._
 //        .-'   `
 //      __|__
 //     /     \
 //     |()_()|
 //     \{o o}/
 //      =\o/=
 //       ^ ^
 */
