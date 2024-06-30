# Task Manager

Task Manager — это приложение на Flutter для управления задачами с поддержкой добавления, редактирования и удаления задач. Приложение поддерживает локализацию, светлую и тёмную темы.

## Установка

1. Убедитесь, что у вас установлены Flutter и Dart.

2. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/vilorg/task_manager.git
   ```
3. Перейдите в папку проекта:
   ```bash
   cd task_manager
   ```
4. Установите зависимости:
   ```bash
   flutter pub get
   ```
5. Установите локали:
   ```bash
   flutter gen-l10n
   ```
6. Создайте файл .env в корне проекта и добавьте туда ваш API токен:
   ```dotenv
   API_TOKEN=your_token_here
   ```
7. Запуск build_runner:
   Для генерации адаптеров Hive и моделей JSON используйте команду:
   ```sh
   flutter pub run build_runner build
   ```

## Запуск приложения

1. Запустите эмулятор или подключите физическое устройство.
2. Выполните команду:
   ```bash
   flutter run
   ```

## Функционал

- Добавление новой задачи
- Редактирование существующей задачи
- Удаление задачи
- Установка важности задачи (Нет, Низкая, Высокая)
- Установка дедлайна задачи
- Поддержка локализации (пока только русский)
- Светлая и тёмная темы
- Синхронизация данных с сервером
- Поддержка оффлайн-режима
- Автоматическая синхронизация оффлайн-данных при восстановлении соединения
- Локальное хранение данных с использованием Hive
- Использование переменных окружения для конфиденциальных данных

### На момент первой итерации сделано:

- Составлена структура проекта
- Сделаны стили
- Добавлены базовые экраны
- Логика сейчас в состоянии "заглушка"

### В рамках второй итерации были реализованы следующие фичи:

- Поддержка работы в оффлайн-режиме
- Автоматическая синхронизация оффлайн-данных при восстановлении соединения
- Хранение данных локально с использованием Hive
- Поддержка переменных окружения для конфиденциальных данных
- Улучшенная структура кода и чистота кода
- Реализация стейт-менеджмента с использованием Cubit
- Логирование с использованием сторонней библиотеки
- Локализация (сделана на первой итерации)

## Структура проекта
##### Проект организован по принципу разделения на фичи и слои. Основные директории включают:

**lib/core** - основные утилиты и вспомогательные классы (например, device_info.dart и network_info.dart)
**lib/features/task** - функциональность, связанная с задачами
**data** - репозитории и модели данных
**domain** - кубиты и состояния
**presentation** - виджеты и страницы

<!-- ![Структура](https://raw.githubusercontent.com/vilorg/task_manager/c07557f39562d94d23fa8754256a9fff7c05e0c3/structure.png) -->

## Скриншоты

![Главный экран](https://raw.githubusercontent.com/vilorg/task_manager/c07557f39562d94d23fa8754256a9fff7c05e0c3/main.png)
![Экран добавления задачи](https://raw.githubusercontent.com/vilorg/task_manager/c07557f39562d94d23fa8754256a9fff7c05e0c3/add_task.png)

## Логирование

Для логирования используется пакет `logger`. Логи записываются для различных действий, таких как добавление, редактирование, удаление задач и установка дедлайна.

## Ссылка на Apk

- [Release Apk](https://drive.google.com/file/d/1wjXPV8shUUWd3qvbQbJYI3JVPkQ8kBgn/view?usp=sharing)

## Авторы

- [Dmitry Petrov](https://github.com/vilorg)
