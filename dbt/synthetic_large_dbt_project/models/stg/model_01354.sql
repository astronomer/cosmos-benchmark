{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00612') }},
        {{ ref('model_00088') }},
        {{ ref('model_00147') }}
)
select id, 'model_01354' as name from sources
