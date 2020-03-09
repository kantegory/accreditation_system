<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>Админ-панель | {{ blank['name'] }}</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<style>
    .list-group-item-action {
    cursor: pointer !important
}
</style>

<body>
    <header class="navbar bg-dark">
        <div class="p-3 navbar-brand text-white">Админ-панель | {{ blank['name'] }}</div>
    </header>
    <main class="d-flex flex-row p-3">
        <aside class="w-25 border border-light bg-light overflow-auto">
            <nav id="" class="navbar navbar-light p-3">
                <div class="list-group w-100 m-auto">
                    <a href="/admin" class="list-group-item list-group-item-action">Создать анкету</a>
                    <a href="/admin" class="list-group-item list-group-item-action">Анкеты на модерации</a>
                    <a href="/admin" class="list-group-item list-group-item-action active">Все анкеты</a>
                    <a href="/admin" class="list-group-item list-group-item-action">Посмотреть отчёты</a>
                </div>
            </nav>
        </aside>
        <article class="container-fluid bg-light">
            <section class="p-3">
                <h2>{{ blank['name'] }}</h2>
                <form class="w-50 m-auto">
                    <div class="form-group">
                        <label for="">Название:</label>
                        <input type="text" class="form-control" placeholder="Название..." value="{{ blank['name'] }}">
                    </div>
                    <div class="d-flex flex-row">
                        <small class="text-muted ml-2">Используемые профстандарты:
                        %for i in range(len(standards)):
                            %if len(standards) - 1 == i:
                                {{ standards[i]}}.
                            %else:
                                {{ standards[i] }},
                            %end
                        %end
                        </small>
                    </div>
                    <div class="form-group">
                        Вопросы:
                        %for i in range(len(questions)):
                        %questionType = ''
                        <div class="form-group mt-2 border border-secondary p-3">
                            %if questions[i]['questionType'] == 'requiredSkill':
                                %questionType = 'Навыки'
                            %elif questions[i]['questionType'] == 'necessaryKnowledge':
                                %questionType = 'Знания'
                            %elif questions[i]['questionType'] == 'laborAction':
                                %questionType = 'Умения'
                            %end
                            <label for="" class="font-weight-bold">{{ questions[i]['question'] }}</label>
                            <p>Тип вопроса: {{ questionType }}</p>
                            <p>Код ТФ: {{ questions[i]['codeTF'] }}</p>
                            <p>Регистрационный номер профстандарта: {{ questions[i]['standardRegistrationNumber'] }}</p>
                            <p>Редактировать текст вопроса:</p>
                            <input type="text" class="form-control" value="{{ questions[i]['question'] }}">
                            <div class="d-flex flex-row mt-2">
                                <button class="btn btn-info">Сохранить</button><button class="btn btn-danger ml-2">Убрать вопрос</button><button class="btn btn-danger ml-2">Убрать все вопросы этой трудовой функции</button>
                            </div>
                        </div>
                        %end
                    </div>
                    <button type="submit" class="btn btn-primary">Сохранить</button>
                </form>
            </section>
        </article>
    </main>
</body>

</html>