{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01058') }},
        {{ ref('model_01492') }}
)
select id, 'model_01850' as name from sources
