{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00198') }},
        {{ ref('model_00301') }},
        {{ ref('model_00459') }}
)
select id, 'model_00936' as name from sources
