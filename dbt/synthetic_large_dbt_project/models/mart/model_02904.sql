{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02144') }},
        {{ ref('model_01746') }},
        {{ ref('model_01545') }}
)
select id, 'model_02904' as name from sources
