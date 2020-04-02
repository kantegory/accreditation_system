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
                <form action="/admin/new_blank" id="blankForm" method="POST" class="w-50 m-auto" enctype="multipart/form-data" onsubmit="sendForm()">
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
                                <input type="file" class="custom-file-input" name="fileInput1" onchange="updateLabel(this.value, this.name)" required>
                                <label class="custom-file-label">Выберите XML-файл...</label>
                            </div>
                        </div>
                        <div class="d-flex flex-row mt-2" id="fileBtns">
                            <button class="btn btn-primary" onclick="editFileAmount('add')" id="addFile">Добавить ещё</button>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="d-flex flex-column">
                            <label for="">Кому предназначена анкета?</label>
                            <small>Введите все почтовые адреса, владельцы которых должны получить доступ к этой анкете, через пробел</small>
                        </div>
                        <div class="d-flex flex-row flex-wrap" id="emails"></div>
                        <input type="email" class="form-control" placeholder="johndoe@gmail.com" name="emails" rows="2" id="putEmail" required>
                        <script>
                            function validateEmail(email) {
                                let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                                return re.test(String(email).toLowerCase());
                            }

                            let emails = localStorage.emails === undefined ? [] : JSON.parse(localStorage.emails);

                            document.querySelector('#putEmail').addEventListener("keyup", function(event) {
                                if (event.key === " ") {
                                    this.value = this.value.replace(/\s/g, '');

                                    if (validateEmail(this.value) !== false && emails.includes(this.value) === false) {
                                        emailAdd(this.value);
                                        this.value = "";
                                    } else {
                                        this.setCustomValidity("Адрес введённой почты некорректен!");
                                    }
                                }
                            });

                            function emailAdd(email) {
                                document.querySelector('#emails').innerHTML += `
                                    <div class="bg-info px-2 py-1 text-white text-center mx-1 my-2 rounded" id="${email}">${email}
                                        <button type="button" class="close ml-2 text-white" onclick="emailDel(this)" data-email="${email}">&times;</button>
                                    </div>
                                `;

                                if (emails.includes(email) === false) {
                                    emails.push(email);
                                    localStorage.emails = JSON.stringify(emails);
                                }
                            }

                            function emailDel(btn) {
                                event.preventDefault();
                                let id = btn.dataset["email"];
                                document.getElementById(`${id}`).remove();

                                emails.splice(emails.indexOf(id), 1);
                                localStorage.emails = JSON.stringify(emails);
                                console.info(emails.length);
                            }

                            // add all emails if localStorage isn't clear
                            window.addEventListener("load", function() {
                                if (emails.length > 0) {
                                    emails.map((email) => { emailAdd(email) });
                                }
                            })

                            function sendForm() {
                                // cancel form submitting
                                this.event.preventDefault();

                                document.querySelector('#putEmail').value = emails.join();

                                // submit the form
                                document.querySelector('#blankForm').submit();
                            }
                        </script>
                    </div>
                    <button type="submit" class="btn btn-primary">Отправить на модерацию</button>
                </form>
            </section>
            <section id="moderate" class="p-3 d-none">
                <h2>Анкеты на модерации</h2>
                <div class="list-group w-50 m-auto">
                    %for moderatingBlank in moderatingBlanks:
                    <a href="admin/blank/{{ moderatingBlank['token'] }}" class="list-group-item list-group-item-action">{{ moderatingBlank['name'] }}</a>
                    <div class="d-flex flex-row">
                        <small class="text-muted ml-2">Используемые профстандарты:
                            %for standard in standards:
                            %if moderatingBlank['token'] == standard['token']:
                            %for i in range(len(standard['standards'])):
                            %prof = standard['standards'][i]
                            %if i == len(standard['standards']) - 1:
                            {{ prof }}.
                            %else:
                            {{ prof }},
                            %end
                            %end
                            %end
                            %end
                        </small>
                    </div>
                    %end
                </div>
            </section>
            <section id="all" class="p-3 d-none">
                <h2>Все анкеты</h2>
                <div class="list-group w-50 m-auto">
                    %for blank in blanks:
                    <a href="admin/blank/{{ blank['token'] }}" class="list-group-item list-group-item-action">{{ blank['name'] }}</a>
                    <div class="d-flex flex-row">
                        <small class="text-muted ml-2">Используемые профстандарты:
                            %for standard in standards:
                            %if blank['token'] == standard['token']:
                            %for i in range(len(standard['standards'])):
                            %prof = standard['standards'][i]
                            %if i == len(standard['standards']) - 1:
                            {{ prof }}.
                            %else:
                            {{ prof }},
                            %end
                            %end
                            %end
                            %end
                        </small>
                    </div>
                    %end
                </div>
            </section>
            <section id="reports" class="p-3 d-none">
                <h2>Отчёты</h2>
                <div class="list-group w-50 m-auto">
                    %for blank in blanks:
                    <a href="/admin/report/{{ blank['token'] }}" class="list-group-item list-group-item-action">Отчёт по анкете {{ blank['name'] }}</a>
                    %end
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
                    <input type="file" class="custom-file-input" required name="fileInput` + fileAmounts + `" onchange="updateLabel(this.value, this.name)">
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

    // add listeners for custom-file-input labels changing to values
    function updateLabel(value, id) {
        let filename = value.split('\\');
        filename = filename[filename.length - 1];

        document.querySelector('#' + id + ' .custom-file-label').innerHTML = filename;
    }
    </script>
</body>

</html>