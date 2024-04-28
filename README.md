## Описание

`CoreDataManager` — это мощный и гибкий инструмент для работы с CoreData в приложениях на iOS. Он предоставляет удобный интерфейс для создания, получения, обновления и удаления сущностей в вашей базе данных. Менеджер полностью обернут в класс с синглтон-доступом для упрощения работы с контекстом CoreData.

## Настройка

Для начала работы с `CoreDataManager`, необходимо проинициализировать его в вашем `AppDelegate` или в начальной точке приложения, указав имя модели данных, которую вы используете в проекте:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    CoreDataManager.configure(withModelName: "CoreDataTestSPM")
    return true
}
```
## Основные методы и их использование

### Создание сущностей
Для создания новой сущности используйте метод createEntity. Этот метод принимает тип сущности и блок конфигурации:
```swift
CoreDataManager.shared?.createEntity(entityType: User.self) { user in
    user.name = "Alice"
    user.age = 30
}
```
Это создаст нового пользователя с именем Alice и возрастом 30 лет.

### Получение сущностей
Для получения сущностей по определенным критериям используйте метод fetchEntities:
```swift
if let users = CoreDataManager.shared?.fetchEntities(entityType: User.self, predicate: NSPredicate(format: "age > %@", "25")) {
    for user in users {
        print("\(user.name) is \(user.age) years old.")
    }
}
```
Это вернет и распечатает всех пользователей старше 25 лет.

### Обновление сущностей
Чтобы обновить сущности, используйте updateEntities:
```swift
CoreDataManager.shared?.updateEntities(entityType: User.self, predicate: NSPredicate(format: "name == %@", "Alice")) { user in
    user.age = 35
}
```
Это обновит возраст пользователя Alice до 35 лет.


### Удаление сущностей
Для удаления сущностей используйте метод deleteEntities:
```swift
CoreDataManager.shared?.deleteEntities(entityType: User.self, predicate: NSPredicate(format: "age < %@", "18"))
```
Это удалит всех пользователей младше 18 лет.


## Сохранение изменений
Чтобы сохранить изменения, сделанные в контексте, не забудьте вызвать saveContext, особенно при переходе приложения в фоновый режим:
```swift
func sceneDidEnterBackground(_ scene: UIScene) {
    CoreDataManager.shared?.saveContext()
}
```

# Заключение
Используя CoreDataManager, вы значительно упрощаете работу с CoreData, обеспечивая структурированный и эффективный подход к управлению данными в вашем приложении.


