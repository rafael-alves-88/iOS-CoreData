//
//  TaskListTableViewController.swift
//  TaskList
//
//  Created by Thales Toniolo on 10/6/15.
//  Copyright © 2015 Flameworks. All rights reserved.
//
import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	var managedObjectContext: NSManagedObjectContext?

	var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()

		self.setupCoreDataStack()

		self.getFetchedResultController()
    }

	func setupCoreDataStack() {
		// ====== Criacao do modelo
		let modelURL: NSURL? = NSBundle.mainBundle().URLForResource("TaskListModel", withExtension: "momd")
		let model = NSManagedObjectModel(contentsOfURL: modelURL!)

		// ====== Criacao do coordenador
		// Instancia um coordinator com o modelo criado
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)

		// Recupera o caminho da documents
		let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
		let docPath: NSURL = NSURL(fileURLWithPath: paths[0])
		print(docPath.absoluteString)

		// Cria o path com o nome do arquivo sqlite
		let sqlitePath = docPath.URLByAppendingPathComponent("TaskListModel.sqlite")

		// Associa o arquivo de persistencia ao coordinator, especificando o tipo SQLite e valida possiveis erros
		do {
			try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: sqlitePath, options: nil)
			self.managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
			self.managedObjectContext!.persistentStoreCoordinator = coordinator
		} catch {
			print("Erro ao associar o coordinator")
		}
	}

	func getFetchedResultController() {
		// Primeiro inicializamos um FetchRequest com dados da tabela Task
		let fetchRequest = NSFetchRequest(entityName: "Task")
		
		// Definimos que o campo usado para ordenação será "nome"
		let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		//Iniciamos a propriedade fetchedResultController com uma instância de NSFetchedResultsController com o FetchRequest acima definido e sem opções de cache
		self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
		
		// A controller será o delegate do fetch
		self.fetchedResultController.delegate = self
		
		// Executa o Fetch
		do {
			try self.fetchedResultController.performFetch()
		} catch {
			print("Erro ao executar o fetch")
		}
	}

    // MARK: - UITableViewDelegate / UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let cont = self.fetchedResultController.fetchedObjects?.count {
			return cont
		}

        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath)

		let task: Task = self.fetchedResultController.objectAtIndexPath(indexPath) as! Task
		cell.textLabel?.text = task.nome!

        return cell
    }

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.Delete) {
			let managedObject: NSManagedObject = self.fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject

			self.managedObjectContext?.deleteObject(managedObject)

			// Salva a task criada
			do {
				try self.managedObjectContext?.save()
			} catch {
				// Escreve erro quando ha
				print("Erro ao remover task")
			}
		}
	}

	// MARK: - NSFetchedResultsControllerDelegate
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		self.tableView.reloadData()
	}


    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let taskController = segue.destinationViewController as! TaskDetailViewController
		taskController.managedObjectContext = self.managedObjectContext
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
