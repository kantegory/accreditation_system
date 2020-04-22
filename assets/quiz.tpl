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
            <div class="d-flex flex-row">
                <h1>{{ blank['name'] }}</h1>
                <div class="d-flex flex-column ml-auto text-secondary text-right">
		  <span>Количество вопросов: {{ len(questions) + 1 }}</span>
		  <span>Все вопросы сохраняются автоматически</span>
		</div>
            </div>
            %if state == "unfinished":
            <form class="w-50 m-auto">
                <fieldset class="w-100 mt-2" id="question0" data-questionType="job" data-answer="" data-question="Стаж вашей работы по специальности" data-registrationNumber="0" data-codeOTF="0">
                    <legend>1. Стаж вашей работы по специальности</legend>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions3_0" name="question0" class="custom-control-input" value="3" onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions3_0">Не работал по специальности</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions2_0" name="question0" class="custom-control-input" value="2" onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions2_0">0-2 лет</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions1_0" name="question0" class="custom-control-input" value="1" required onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions1_0">Более 2 лет</label>
                    </div>
                </fieldset>
                %prev_question_type = "job"
                %for i in range(len(questions)):
		%if questions[i]['questionType'] != prev_question_type:
		%prev_question_type = questions[i]['questionType']
		%question_types = {"requiredSkill": "Навыки", "necessaryKnowledge": "Знания", "laborAction": "Трудовые действия"}
		<div class="d-flex flex-column my-2 lead">
                  <span><strong>Профессиональный стандарт:</strong> {{ questions[i]['standardRegistrationNumber'] }}</span>
		  <span><strong>Трудовая функция:</strong> {{ questions[i]['codeTF'] }}</span>
		  <span><strong>Тип вопроса:</strong> {{ question_types[questions[i]['questionType']] }}</span>
		</div>
		%end
                <fieldset class="w-100 mt-2 question" id="question{{ i + 1 }}" data-questionType="{{ questions[i]['questionType'] }}" data-registrationNumber="{{ questions[i]['standardRegistrationNumber'] }}" data-answer="" data-codeOTF="{{ questions[i]['codeTF'] }}" data-question="{{ questions[i]['question'] }}">
                    <legend>{{ i + 2 }}. {{ questions[i]['question'] }}</legend>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions5_{{ i + 1 }}" name="question{{ i + 1 }}" class="custom-control-input" value="5" onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions5_{{ i + 1 }}">Освоил в образовательной организации и соответствует требованиям работодателя</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions4_{{ i + 1 }}" name="question{{ i + 1 }}" class="custom-control-input" value="4" onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions4_{{ i + 1 }}">Частично освоил в образовательной организации и соответствует требованиям работодателя</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions3_{{ i + 1 }}" name="question{{ i + 1 }}" class="custom-control-input" value="3" onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions3_{{ i + 1 }}">Освоил в образовательной организации, но не востребовано на рабочем месте</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions2_{{ i + 1 }}" name="question{{ i + 1 }}" class="custom-control-input" value="2" onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions2_{{ i + 1 }}">Частично освоил в образовательной организации, но не востребовано на рабочем месте</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" id="questions1_{{ i + 1 }}" name="question{{ i + 1 }}" class="custom-control-input" value="1" required onclick="writeAnswer(this.id)" required="">
                        <label class="custom-control-label" for="questions1_{{ i + 1 }}">Не было в программе образовательной организации, но востребовано на рабочем месте</label>
                    </div>
                </fieldset>
                %end
                <button class="btn btn-primary mt-2" onclick="success()" data-toggle="modal" data-target="#success">Отправить</button>
            </form>
            %else:
            <h2 class="w-100 text-center">Вы уже прошли анкету</h2>
            %end
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
    function writeAnswer(id) {
	console.log("i write this question id", id);
        let currID = parseInt(id.split('_')[1]);
	console.log("this is currID", currID);
        let fieldsetID = 'question' + currID;

        document.querySelector('#' + fieldsetID).dataset.answer = document.querySelector('#' + id).value;

        saveResults(currID);
    };

    function saveResults(id) {
        let dataset = [JSON.stringify(document.querySelector('#question' + id).dataset)];
	let answer = JSON.parse(dataset[0]).answer;

        console.log("dataset", dataset);

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
            body: JSON.stringify(dataset)
        }).then((result) => { console.log(result) })

        let questionID = '#question' + id;
	console.log('this is answer', answer);
        let answerID = '#questions' + answer + '_' + id;

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

    function success(event) {
        event.preventDefault();

        localStorage.clear();

        window.location.href = "http://aorpo.spb.ru"
    }
    </script>
</body>

</html>
