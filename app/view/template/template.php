<!DOCTYPE html>
<html lang="pt">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Obras Públicas</title>
    <link rel="stylesheet" href="vendor/twbs/bootstrap/dist/css/bootstrap.css" />
</head>

<body>
    <div class="container-fluid">

        {% include 'template/header.php' %}

        {% block body %}
        {% endblock %}

        {% include 'template/footer.php' %}
    </div>

</body>
<script src="{{BASE}}vendor/twbs/bootstrap/dist/js/bootstrap.min.js"></script>

</html>