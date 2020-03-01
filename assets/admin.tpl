<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>Админ-панель</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<style>
    .list-group-item-action, .custom-file-input {
		cursor: pointer !important
	}
</style>

<body>
    <header class="navbar bg-dark">
        <div class="p-3 navbar-brand text-white">Админ-панель</div>
    </header>
    <main class="d-flex flex-row p-3">
        <aside class="w-25 border border-light bg-light overflow-auto">
            <nav id="" class="navbar navbar-light p-3">
                <div class="list-group w-100 m-auto" id="navLinks">
                    <a data-id="#create" class="list-group-item list-group-item-action active text-white" onclick="goTo(this)">Создать анкету</a>
                    <a data-id="#moderate" class="list-group-item list-group-item-action" onclick="goTo(this)">Анкеты на модерации</a>
                    <a data-id="#all" class="list-group-item list-group-item-action" onclick="goTo(this)">Все анкеты</a>
                    <a data-id="#reports" class="list-group-item list-group-item-action" onclick="goTo(this)">Посмотреть отчёты</a>
                </div>
            </nav>
        </aside>
        <article class="container-fluid bg-light" id="sections">
            <section id="create" class="p-3">
                <h2>Создать анкету</h2>
                <form action="/admin/new_blank" method="POST" class="w-50 m-auto" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="">Название:</label>
                        <input type="text" class="form-control" placeholder="Название..." name="blank_name">
                    </div>
                    <div class="form-group">
                        Стандарты:
                        <div id="fileInputs">
                            <p class="text-muted p-0 m-0">
                                <small>XML-файлы проф. стандартов можно скачать
                                    <a href="https://profstandart.rosmintrud.ru/obshchiy-informatsionnyy-blok/natsionalnyy-reestr-professionalnykh-standartov/reestr-professionalnykh-standartov/">отсюда</a>
                                </small>
                            </p>
                            <div class="custom-file mt-2" id="fileInput1">
                                <input type="file" class="custom-file-input" name="fileInput1" required>
                                <label class="custom-file-label">Выберите XML-файл...</label>
                            </div>
                        </div>
                        <div class="d-flex flex-row mt-2" id="fileBtns">
                            <button class="btn btn-primary" onclick="editFileAmount('add')" id="addFile">Добавить ещё</button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Дата начала:</label>
                        <input type="date" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="">Дата конца:</label>
                        <input type="date" class="form-control">
                    </div>
                    <button type="submit" class="btn btn-primary">Отправить на модерацию</button>
                </form>
            </section>
            <section id="moderate" class="p-3 d-none">
                <h2>Анкеты на модерации</h2>
                <div class="list-group w-50 m-auto">
                    <a class="list-group-item list-group-item-action">Анкета 1</a>
                </div>
            </section>
            <section id="all" class="p-3 d-none">
                <h2>Все анкеты</h2>
                <div class="list-group w-50 m-auto">
                    <a class="list-group-item list-group-item-action">Анкета 1</a>
                </div>
            </section>
            <section id="reports" class="p-3 d-none">
                <h2>Отчёты</h2>
                <div class="list-group w-50 m-auto">
                    <a class="list-group-item list-group-item-action">Отчёт по анкете 1</a>
                </div>
            </section>
        </article>
    </main>
    <script type="text/javascript">
    let fileAmounts = 1;

    function editFileAmount(action) {
        event.preventDefault();
        if (action === "add") {
            fileAmounts++;
            document.querySelector('#fileInputs').innerHTML += `
				<div class="custom-file mt-2" id="fileInput` + fileAmounts + `">
                    <input type="file" class="custom-file-input" required name="fileInput` + fileAmounts + `">
                    <label class="custom-file-label">Выберите XML-файл...</label>
                </div>
        	`;
            if (fileAmounts < 3) {
                document.querySelector('#fileBtns').innerHTML += `
                	<button class="btn btn-danger ml-2" onclick="editFileAmount('del')" id="delFile">Удалить</button>
        		`
            } else if (fileAmounts === 5) {
                document.querySelector('#addFile').remove();
                document.querySelector('#delFile').classList.remove('ml-2')
            }
        } else if (action === "del") {
            document.querySelector('#fileInput' + fileAmounts).remove();
            fileAmounts--;
            if (fileAmounts < 2) {
                document.querySelector('#delFile').remove();
            } else if (fileAmounts === 4) {
                document.querySelector('#fileBtns').innerHTML = `
                    <button class="btn btn-primary" onclick="editFileAmount('add')" id="addFile">Добавить ещё</button>
                	<button class="btn btn-danger ml-2" onclick="editFileAmount('del')" id="delFile">Удалить</button>
        		`
            }
        }
    }

    function goTo(elem) {
        let id = elem.dataset.id;
        Array.from(document.querySelector('#navLinks').querySelectorAll('a')).map((elem) => { elem.classList.remove('active', 'text-white') });
        elem.classList.add('active', 'text-white');
        Array.from(document.querySelectorAll('#sections section')).map((elem) => { elem.classList.add('d-none') });
        document.querySelector(id).classList.remove('d-none');
    }
    </script>
</body>

</html>