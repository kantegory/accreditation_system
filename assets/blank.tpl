<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>Админ-панель | Редактирование {{ blank['name'] }}</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
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
                    <a href="/admin#create" class="list-group-item list-group-item-action">Создать анкету</a>
                    <a href="/admin#moderate" class="list-group-item list-group-item-action">Анкеты на модерации</a>
                    <a href="/admin#all" class="list-group-item list-group-item-action active">Все анкеты</a>
                    <a href="/admin#reports" class="list-group-item list-group-item-action">Посмотреть отчёты</a>
                </div>
            </nav>
        </aside>
        <article class="container-fluid bg-light">
            <section class="p-3">
                <h2>{{ blank['name'] }}</h2>
                <div class="blank-form my-2 mx-auto">
                    <div class="form-group">
                        Ссылка на анкету:  <input type="text" value="{{ hostname }}:{{ port }}/quiz/{{ token }}" class="form-control w-50">
                    </div>
                    %if blank['state'] != 'sent':
                        <button class="btn btn-primary" onclick="sendEmail()">Разослать уведомление</button>
                    %else:
                        <button class="btn btn-primary" disabled="">Уведомление отправлено</button>
                    %end
                </div>
                <form class="blank-form m-auto">
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
                        <div class="question form-group mt-2 border border-secondary p-3" id="question{{ i }}" data-id="{{ questions[i]['id'] }}"
                        data-questionType="{{ questions[i]['questionType'] }}" data-registrationNumber="{{ questions[i]['standardRegistrationNumber'] }}"
                        data-codeOTF="{{ questions[i]['codeTF'] }}" data-question="{{ questions[i]['question'] }}">
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
                            <textarea type="text" class="form-control" rows="4" style="resize: none">{{ questions[i]['question'] }}</textarea>
                            <div class="d-flex flex-row mt-2 flex-wrap">
                                <button class="btn btn-info mx-1 my-1" data-id="question{{ i }}" onclick="saveQuestion(this)">Сохранить</button>
                                <button class="btn btn-danger mx-1 my-1" data-id="question{{ i }}" onclick="delQuestion(this)">Убрать вопрос</button>
                                <button class="btn btn-danger mx-1 my-1" data-codeOTF="{{ questions[i]['codeTF'] }}" onclick="delTF(this)">Убрать ТФ</button>
                            </div>
                        </div>
                        %end
                         <style>
                                .btn.mx-1:first-child {
                                    margin-left: 0 !important;
                                }

                                .btn.mx-1:last-child {
                                    margin-right: 0 !important;
                                }

                                .blank-form {
                                    width: 50%;
                                }

                                @media (min-width: 1025px) and (max-width: 1537px) {
                                    .blank-form {
                                        width: 75%;
                                    }
                                }

                                @media screen and (max-width: 1025px) {
                                    .blank-form {
                                        width: 100%;
                                    }
                                }
                            </style>
                    </div>
                    <button type="submit" class="btn btn-primary" onclick="sendQuestions()" data-toggle="modal" data-target="#success">Сохранить</button>
                </form>
            </section>
        </article>
    </main>
    <div class="modal" tabindex="-1" role="dialog" id="success">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Анкета сохранена</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Анкета успешно сохранена!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Закрыть</button>
                </div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
    function saveQuestion(question) {
        this.event.preventDefault();

        let questionID = question.dataset["id"];
        let currQuestion = document.querySelector(`#${questionID}`);
        currQuestion.dataset["question"] = currQuestion.querySelector('textarea').value;
        console.log(currQuestion.dataset["question"]);
    }

    function delQuestion(question) {
        this.event.preventDefault();

        let questionId = question.dataset["id"];
        document.querySelector(`#${questionId}`).remove();
    }

    function delTF(tf) {
        this.event.preventDefault();
        console.log(tf);
        let tfID = tf.dataset["codeotf"];
        // del all questions of this OTF code
        Array.from(document.querySelectorAll('.question')).map((question) => {
            if (question.dataset["codeotf"] === tfID) {
                question.remove();
            }
        })
    }

    function sendQuestions() {
        event.preventDefault();

        let questionData = Array.from(document.querySelectorAll('.question')).map((question) => { return JSON.stringify(question.dataset) });

        console.log(questionData);

        let url = '/admin/save_blank/{{ token }}';

        fetch(url, {
            method: 'POST',
            mode: 'cors',
            cache: 'no-cache',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/json',
            },
            redirect: 'follow', // manual, *follow, error
            referrer: 'no-referrer',
            body: JSON.stringify(questionData)
        }).then((result) => { console.log(result); });

    }

    function sendEmail() {
        event.preventDefault();

        let url = '/admin/send_email/{{ token }}';

        window.location = url;
    }
</script>
</html>