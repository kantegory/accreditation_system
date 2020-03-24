<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>{{ blank['name'] }}</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</head>
<style>
    .list-group-item-action, .custom-radio > * {
    cursor: pointer !important
}
</style>

<body>
    <header class="navbar bg-dark">
        <div class="p-3 navbar-brand text-white">{{ blank['name'] }}</div>
    </header>
    <main class="d-flex flex-row p-3 bg-light">
        <section class="container-fluid">
            <h2>{{ blank['name'] }}</h2>
            <form class="w-50 m-auto">
                %for i in range(len(questions)):
                <fieldset class="w-100 mt-2" id="question{{ i }}" data-questionType="{{ questions[i]['questionType'] }}" data-registrationNumber="{{ questions[i]['standardRegistrationNumber'] }}" data-answer="" data-codeOTF="{{ questions[i]['codeTF'] }}" data-question="{{ questions[i]['question'] }}">
                    <legend>Выберите наиболее подходящее утверждение для следующей компетенции:</legend>
                    <p>{{ questions[i]['question'] }}</p>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions5_{{ i }}" name="question{{ i }}" class="custom-control-input" value="5" onclick="writeAnswer(this.id)">
                        <label class="custom-control-label" for="questions5_{{ i }}">Освоил в образовательной организации и соответствует требованиям работодателя</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions4_{{ i }}" name="question{{ i }}" class="custom-control-input" value="4" onclick="writeAnswer(this.id)">
                        <label class="custom-control-label" for="questions4_{{ i }}">Частично освоил в образовательной организации и соответствует требованиям работодателя</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions3_{{ i }}" name="question{{ i }}" class="custom-control-input" value="3" onclick="writeAnswer(this.id)">
                        <label class="custom-control-label" for="questions3_{{ i }}">Освоил в образовательной организации, но не востребовано на рабочем месте</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions2_{{ i }}" name="question{{ i }}" class="custom-control-input" value="2" onclick="writeAnswer(this.id)">
                        <label class="custom-control-label" for="questions2_{{ i }}">Частично освоил в образовательной организации, но не востребовано на рабочем месте</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions1_{{ i }}" name="question{{ i }}" class="custom-control-input" value="1" required onclick="writeAnswer(this.id)">
                        <label class="custom-control-label" for="questions1_{{ i }}">Не было в программе образовательной организации, но востребовано на рабочем месте</label>
                    </div>
                </fieldset>
                %end
                <button class="btn btn-primary mt-2" onclick="sendResults()" data-toggle="modal" data-target="#success">Отправить</button>
            </form>
        </section>
    </main>
    <div class="modal" tabindex="-1" role="dialog" id="success">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Спасибо!</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Спасибо за прохождение анкеты!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Закрыть</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    function sendResults() {
        event.preventDefault();

        let questionData = [];

        % for i in range(len(questions)):
            questionData.push(JSON.stringify(document.querySelector('#question{{ i }}').dataset));
        % end

        let url = '/quiz/{{ token }}/{{ user_id }}';

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
        }).then((result) => { console.log(result); window.location = "http://aorpo.spb.ru/"; });
    };

    let questionTmpId = 0;

    function writeAnswer(id) {
        let currID = parseInt(id.split('_')[1]);
        let fieldsetID = 'question' + currID;

        document.querySelector('#' + fieldsetID).dataset.answer = document.querySelector('#' + id).value;

        if (currID - questionTmpId === 1) {
            saveResults(questionTmpId);
            questionTmpId = currID;
        }
    };

    function saveResults(id) {
        console.log(id)
        let questionData = [];
        let dataset = document.querySelector('#question' + id).dataset;

        questionData.push(JSON.stringify(dataset));

        let url = '/quiz/{{ token }}/{{ user_id }}';

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
        }).then((result) => { console.log(result) })

        let questionID = '#question' + id;
        let answerID = '#questions' + dataset.answer + '_' + id;

        localStorage.setItem(questionID, answerID);
    };

    window.addEventListener('load', function() {
        if (localStorage.length > 0) {
            for (let i = 0; i < localStorage.length; i++) {
                let answerID = localStorage.getItem('#question' + i);
                document.querySelector(answerID).checked = true;
            }
        }
    });
    </script>
</body>

</html>