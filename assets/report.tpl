<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>Админ-панель | Отчёт по анкете {{ blank['name'] }}</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<style>
.list-group-item-action {
    cursor: pointer !important
}
</style>

<body>
    <header class="navbar bg-dark">
        <div class="p-3 navbar-brand text-white">Админ-панель | Отчёт по анкете {{ blank['name'] }}</div>
    </header>
    <main class="d-flex flex-row p-3">
        <aside class="w-25 border border-light bg-light overflow-auto">
            <nav id="" class="navbar navbar-light p-3">
                <div class="list-group w-100 m-auto">
                    <a href="/admin#create" class="list-group-item list-group-item-action">Создать анкету</a>
                    <a href="/admin#moderate" class="list-group-item list-group-item-action">Анкеты на модерации</a>
                    <a href="/admin#all" class="list-group-item list-group-item-action">Все анкеты</a>
                    <a href="/admin#reports" class="list-group-item list-group-item-action active">Посмотреть отчёты</a>
                </div>
            </nav>
        </aside>
        <article class="container-fluid bg-light">
            <section class="p-3">
                <h2>Отчёт по анкете {{ blank['name'] }}</h2>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="row">#</th>
                            <td>E-mail выпускника</td>
                            <td>Процент отвеченного</td>
                        </tr>
                    </thead>
                    <tbody>
                        %for user in user_stat:
                        <tr>
                            <th scope="row">{{ user_stat.index(user) + 1 }}</th>
                            <td>{{ user['user_email'] }}</td>
                            <td>{{ user['stat'] }}%</td>
                        </tr>
                        %end
                    </tbody>
                </table>
            </section>
        </article>
    </main>
</body>

</html>