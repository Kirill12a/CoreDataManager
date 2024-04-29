## Описание

`CoreDataManager` — это мощный и гибкий инструмент для работы с CoreData в приложениях на iOS. Он предоставляет удобный интерфейс для создания, получения, обновления и удаления сущностей в вашей базе данных. Менеджер полностью обернут в класс с синглтон-доступом для упрощения работы с контекстом CoreData.

## Установка

### Swift Package Manager

Чтобы добавить `CoreDataManager` в ваш проект iOS через Swift Package Manager, добавьте следующую зависимость в ваш `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Kirill12a/CoreDataManager", .upToNextMajor(from: "1.0.0"))
]
```

## Настройка

Для начала работы с `CoreDataManager`, необходимо проинициализировать его в вашем `AppDelegate` или в начальной точке приложения, указав имя модели данных, которую вы используете в проекте:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    CoreDataManager.configure(withModelName: "CoreDataTestSPM")
    return true
}
```

## Включение Режима Отладки
Для активации отладочного вывода в консоль при работе с CoreData, необходимо установить специальный аргумент запуска. Это позволит вам отслеживать детальную информацию о процессах взаимодействия с базой данных во время разработки вашего приложения.
###
Настройка Xcode
1. Откройте проект в Xcode и перейдите к схеме запуска вашего приложения, выбрав Product > Scheme > Edit Scheme в верхнем меню.
2. В открывшемся окне схемы перейдите в раздел Arguments.
3. В подразделе Arguments Passed On Launch добавьте новый аргумент:
```diff
-CoreDataDebugMode
```
4. Убедитесь, что этот аргумент активирован (слева от него должен быть установлен флажок).

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

### Удаление всей сущности
Для удаления всей сущности используйте метод deleteAllEntities:
```swift
CoreDataManager.shared?.deleteAllEntities(entityType: User.self)
```

## Сохранение изменений
Чтобы сохранить изменения, сделанные в контексте, не забудьте вызвать saveContext, особенно при переходе приложения в фоновый режим:
```swift
func sceneDidEnterBackground(_ scene: UIScene) {
    CoreDataManager.shared?.saveContext()
}
```

## Заключение
Используя CoreDataManager, вы значительно упрощаете работу с CoreData, обеспечивая структурированный и эффективный подход к управлению данными в вашем приложении.


