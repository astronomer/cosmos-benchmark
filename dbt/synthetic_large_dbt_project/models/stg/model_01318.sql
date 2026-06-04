{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00597') }},
        {{ ref('model_00024') }},
        {{ ref('model_00465') }}
)
select id, 'model_01318' as name from sources
