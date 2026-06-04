{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02154') }},
        {{ ref('model_02088') }},
        {{ ref('model_01793') }}
)
select id, 'model_02972' as name from sources
