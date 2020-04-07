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
                <div class="d-flex flex-row">
                    <h2>Отчёт по анкете <span id="reportName">{{ blank['name'] }}</span></h2>
                    <button class="btn btn-primary ml-auto" id="export">Скачать полный отчёт</button>
                </div>
                <h4 class="my-4">Итог анализа:</h4>
                {{ analysis }}
                <h4 class="my-4">Процесс:</h4>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="row">#</th>
                            <th>E-mail выпускника</th>
                            <th>Процент отвеченного</th>
                        </tr>
                    </thead>
                    <tbody>
                        %for user in user_stat:
                        <tr>
                            <td scope="row">{{ user_stat.index(user) + 1 }}</td>
                            <td>{{ user['user_email'] }}</td>
                            <td>{{ user['stat'] }}%</td>
                        </tr>
                        %end
                    </tbody>
                </table>
                <table id="fullReport" class="d-none">
                <thead>
                    <tr>
                        <th>Пользователь (ID в базе)</th>
                        <th>Тип вопроса</th>
                        <th>Вопрос</th>
                        <th>Ответ</th>
                    </tr>
                </thead>
                <tbody>
                %questionTypes = {"requiredSkill": "Навыки", "necessaryKnowlende": "Знания", "laborActions": "Действия", "job": 0}
                %answers = ["Не было в программе образовательной организации, но востребовано на рабочем месте", "Частично освоил в образовательной организации, но не востребовано на рабочем месте", "Освоил в образовательной организации, но не востребовано на рабочем месте", "Частично освоил в образовательной организации и соответствует требованиям работодателя", "Освоил в образовательной организации и соответствует требованиям работодателя"]

                %for report in reports:
                    %questionType = questionTypes[report["questionType"]]
                    %if questionType != 0:
                        %answer = answers[int(report["answer"]) - 1]
                        <tr>
                            <td>{{ report["userId"] }}</td>
                            <td>{{ questionType }}</td>
                            <td>{{ report["question"] }}</td>
                            <td>{{ answer }}</td>
                        </tr>
                    %end
                %end
                </tbody>
            </section>
        </article>
    </main>
</body>
<script type="text/javascript">
    let tableToExcel = (function() {
    let uri = 'data:application/vnd.ms-excel;base64,',
        template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--><meta http-equiv="content-type" content="text/plain; charset=UTF-8"/></head><body><table>{table}</table></body></html>',
        base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
        format = function(s, c) {
            return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; })
        },
        downloadURI = function(uri, name) {
            let link = document.createElement("a");
            link.download = name;
            link.href = uri;
            link.click();
        };

    return function(table, name, fileName) {
        console.log("table is", table);
        if (!table.nodeType) table = document.getElementById(table);
        let ctx = { worksheet: name || 'Worksheet', table: table.innerHTML };
        let resUri = uri + base64(format(template, ctx));
        downloadURI(resUri, fileName);
    }
})();
let table_name = document.querySelector('#reportName').innerHTML;
document.querySelector('#export').onclick = function() { tableToExcel('fullReport', table_name, table_name + '.xls') };
</script>

</html>