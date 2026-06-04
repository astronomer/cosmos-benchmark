{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00097') }},
        {{ ref('model_00633') }},
        {{ ref('model_00370') }}
)
select id, 'model_01297' as name from sources
