{% macro get_model_param(model_name) %}
    {% set seeds = load_seed('config') %}
    {% for row in seeds %}
        {% if row['model_name'] == model_name %}
            {% do return(row) %}
        {% endif %}
    {% endfor %}
    {% do exceptions.raise_compiler_error("Model '" ~ model_name ~ "' not found in seed 'config'") %}
{% endmacro %}
