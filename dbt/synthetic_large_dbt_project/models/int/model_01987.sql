{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01009') }},
        {{ ref('model_01350') }},
        {{ ref('model_01169') }}
)
select id, 'model_01987' as name from sources
