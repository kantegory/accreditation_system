<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>Админ-панель | Анкета 1</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<style>
    .list-group-item-action {
    cursor: pointer !important
}
</style>

<body>
    <header class="navbar bg-dark">
        <div class="p-3 navbar-brand text-white">Админ-панель | Анкета 1</div>
    </header>
    <main class="d-flex flex-row p-3">
        <aside class="w-25 border border-light bg-light overflow-auto">
            <nav id="" class="navbar navbar-light p-3">
                <div class="list-group w-100 m-auto">
                    <a href="" class="list-group-item list-group-item-action">Создать анкету</a>
                    <a href="" class="list-group-item list-group-item-action">Анкеты на модерации</a>
                    <a href="" class="list-group-item list-group-item-action active">Все анкеты</a>
                    <a href="" class="list-group-item list-group-item-action">Посмотреть отчёты</a>
                </div>
            </nav>
        </aside>
        <article class="container-fluid bg-light">
            <section class="p-3">
                <h2>Анкета 1</h2>
                <form class="w-50 m-auto">
                    <div class="form-group">
                        <label for="">Название:</label>
                        <input type="text" class="form-control" placeholder="Название...">
                    </div>
                    <div class="form-group">
                        <label for="">Дата начала:</label>
                        <input type="date" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="">Дата конца:</label>
                        <input type="date" class="form-control">
                    </div>
                    <div class="form-group">
                        Вопросы:
                        <div class="form-group mt-2">
                            <label for="">Вопрос 1:</label>
                            <input type="text" class="form-control" value="Вопрос 1">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Сохранить</button>
                </form>
            </section>
        </article>
    </main>
</body>

</html>