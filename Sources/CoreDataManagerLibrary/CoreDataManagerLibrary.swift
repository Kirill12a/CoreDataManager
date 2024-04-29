// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreData

public final class CoreDataManager {
    public static var shared: CoreDataManager?

    private let persistentContainer: NSPersistentContainer

    // Публичный статический метод для инициализации менеджера с названием модели данных
    public static func configure(withModelName modelName: String) {
        shared = CoreDataManager(modelName: modelName)
        print("🌟 CoreDataManager configured with model: \(modelName)")
    }

    // Закрытый инициализатор для инициализации с конкретным именем модели данных
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("📡 Database URL: \(storeDescription.url?.absoluteString ?? "N/A")")
        }
    }

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Метод для сохранения контекста
    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("💾 Context saved successfully.")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Создание новой сущности с конфигурацией
    public func createEntity<T: NSManagedObject>(entityType: T.Type, configure: (T) -> Void) {
        let entityName = String(describing: entityType)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Could not find entity name: \(entityName)")
        }
        let entity = T(entity: entityDescription, insertInto: context)
        configure(entity)
        saveContext()
        print("🆕 Created new \(entityName).")
    }

    // Получение сущностей по условию
    public func fetchEntities<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest)
            print("🔍 Found \(results.count) \(entityName)(s) matching predicate.")
            return results
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }

    // Обновление сущностей по условию
    public func updateEntities<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate, configure: (T) -> Void) {
        let entities = fetchEntities(entityType: entityType, predicate: predicate)
        entities.forEach(configure)
        saveContext()
        print("🔄 Updated \(entities.count) \(String(describing: entityType)) entities.")
    }

    // Удаление сущностей по условию
    public func deleteEntities<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate) {
        let entities = fetchEntities(entityType: entityType, predicate: predicate)
        entities.forEach(context.delete)
        saveContext()
        print("🗑 Deleted \(entities.count) \(String(describing: entityType)) entities.")
    }

    // Удаление всех значений в сущности
    public func deleteAllEntities<T: NSManagedObject>(entityType: T.Type) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: entityType))
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            saveContext()
            print("🗑 Deleted all objects of type \(entityType).")
        } catch {
            print("Error deleting objects: \(error)")
        }
    }
}

