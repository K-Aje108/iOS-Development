//
//  ViewController.swift
//  MProject 10
//
//  Created by Kanyin Aje on 26/09/2020.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictures = [Pictures]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard

        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictures = try jsonDecoder.decode([Pictures].self, from: savedPictures)
                // attempt to create an array pf Pictures objects
            } catch {
                print("Failed to load people")
            }
        }
    
    }
    
    @objc func addNewPerson() {
      let picker = UIImagePickerController()
      if  UIImagePickerController.isSourceTypeAvailable(.camera) {
          picker.sourceType = .camera
    }
    else {
        picker.allowsEditing = true //allows user to crop the picture
        picker.delegate = self //telling us when the user either selected a picture or cancelled the picker.
        present(picker, animated: true)
    }

 }
    /*Extract the image from the dictionary that is passed as a parameter.
        Generate a unique filename for it.
        Convert it to a JPEG, then write that JPEG to disk.
        Dismiss the view controller.*/
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    // Delegate method.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
  
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString///We then create an UUID object, and use its uuidString property to extract the unique identifier as a string data type.
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let picture = Pictures(image: imageName, caption: "")
        pictures.append(picture)
        tableView.reloadData()
        save()
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Enter Caption: ", message: nil , preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            picture.caption = answer
            self?.save()
            self?.tableView.reloadData()
            
          
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

         let picture = pictures[indexPath.row]
         let path = getDocumentsDirectory().appendingPathComponent(picture.image)
         cell.imageView?.image = UIImage(contentsOfFile: path.path)
         cell.textLabel?.text = picture.caption

        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.row]
            let path = getDocumentsDirectory().appendingPathComponent(picture.image)
            vc.selectedImage = path.path
            
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save people.")
        }
    }

}

//called UUID, which generates a Universally Unique Identifier and is perfect for a random filename.
// Once again, note the interesting syntax for decode() method: its first parameter is [Person].self, which is Swift’s way of saying “attempt to create an array of Person objects.” This is why we don’t need a typecast when assigning to people – that method will automatically return [People], or if the conversion fails then the catch block will be executed instead.
// Create a UIImage from the person's image filename, adding it to the value from getDocumentsDirectory() so that we have a full path for the image.
// You met Apple’s appendingPathComponent() method, as well as my own getDocumentsDirectory() helper method. Combined, these two let us create filenames that are saved to the user’s documents directory. You could, in theory, create the filename by hand, but using appendingPathComponent() is safer because it means your code won’t break if things change in the future.
