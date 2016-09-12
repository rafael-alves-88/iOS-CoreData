//
//  TaskDetailViewController.swift
//  TaskList
//
//  Created by Thales Toniolo on 10/6/15.
//  Copyright © 2015 Flameworks. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class TaskDetailViewController: UIViewController {

	var managedObjectContext: NSManagedObjectContext?

	@IBOutlet weak var txtDesc: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func addTask(sender: UIBarButtonItem) {
		// Cria uma variavel para referenciar a tabela task
		let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.managedObjectContext!)

		// Cria uma instancia da task
		let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)

		// Atribui o valor nome para instancia da task
		task.nome = self.txtDesc.text!

		// Salva a task criada
		do {
			try self.managedObjectContext?.save()

			// Apos adicao com sucesso, retorna a tela de listagem de tasks
			self.navigationController?.popViewControllerAnimated(true)
		} catch {
			// Escreve erro quando ha
			print("Erro ao salvar task")
		}
	}
}
