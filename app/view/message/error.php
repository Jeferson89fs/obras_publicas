{% extends "template/template.php" %}

{% block title %}teste{%endblock%}

{% block body %}
<div class="content-wrapper">

    <div class="alert alert-danger d-flex align-items-center" role="alert">
        <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Danger:">
            <use xlink:href="#exclamation-triangle-fill" />
        </svg>
        <div>
            {{msg_error}}
        </div>
    </div>
</div>

{% endblock %}