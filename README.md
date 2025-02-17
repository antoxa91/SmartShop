- # Тестовое задание для стажёра iOS-направления (зимняя волна 2025)

  ---

  ## Общее

  - **Технологии**: `UIKit`
  - **API**: Получение данных из [FakeAPI](https://fakeapi.platzi.com/)
  - **Дизайн**: Использован бесплатный макет с Dribbble.com.

  ---

  ## Экран 1 — Поисковый экран

  ### Основные функции:

  - ✅ **Список товаров** с постраничной загрузкой (Pagination) с использованием `UICollectionView`.
  - ✅ **Поиск по тексту**: При нажатии на `UITextField` отображаются 5 последних поисковых запросов с помощью `UITableView`.
  - ✅ **Фильтрация**: При нажатии на кнопку фильтра открывается *Bottom Sheet* с настройками. Поддержка всех 4 фильтров из описания API с возможностью применения нескольких фильтров одновременно. Кнопка для сброса всех фильтров.
  - ✅ **Отображение категорий**: Для категорий 1 и 2 (одежда и электроника) ячейка отображается на всю ширину экрана.
  - ✅ **Empty-state**: Сообщение, если ничего не найдено, и возможность перезапроса при ошибке загрузки.
  - ✅ **Кнопка перехода** к списку покупок.

<details>
 
![1 screen](https://github.com/user-attachments/assets/01a8e6ba-eeed-445b-b557-f3895eafcae3)
 
</details>

  ---

  ## Экран 2 — Карточка товара

  ### Основные функции:

  - ✅ **Галерея изображений**: Возможность просматривать все доступные изображения товара с помощью `UIPageViewController`. При ошибке загрузки отображается изображение-заполнитель.
  - ✅ **Информация о товаре**: Заголовок, описание, цена и категория. Используется `UIScrollView`, если описание превышает размер экрана.
  - ✅ **Поделиться информацией** о товаре (только текст).
  - ✅ **Кнопка добавления в «Список покупок»**:
    - Если товар не добавлен, он добавляется в список, и заголовок кнопки меняется.
    - Если товар уже в списке, происходит переход к экрану «Списка покупок».
    - Элементы управления для добавления или удаления количества товара (+/-).

  ---

  ## Экран 3 — Список покупок

  ### Основные функции:

  - ✅ **Список товаров**, добавленных на втором экране, с использованием `UITableView`.
  - ✅ Для каждого айтема отображается изображение, цена и количество.
  - ✅ Возможность:
    - Купить несколько штук одного товара.
    - Удалить айтем по свайпу.
    - Очистить весь список нажатием на кнопку.
  - ✅ **Персистентность**: Список сохраняется при перезапуске приложения с использованием `FileManager`.
  - ✅ **Кнопка «Поделиться»**: Отправка списка покупок в виде текста в мессенджере или сохранение в «Заметки».
  - ✅ **Синхронизация стейта**: Список покупок синхронизирован с карточками айтемов и экраном выдачи.
  - ✅ По клику на айтем происходит переход на карточку товара.
  - ✅ Возможность менять порядок айтемов перетаскиванием.

  ---

  ## Дополнительно

  ### Используемые технологии и паттерны:

  - `Auto Layout`
  - `OSLog`
  - `UIStackView`
  - `AttributedString`
  - `Dependency Injection (DI)`
  - `Singleton`
  - `Delegate`
  - Кастомные цвета
  - Анимации для улучшения пользовательского опыта (UX)
