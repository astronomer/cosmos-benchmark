{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00126') }},
        {{ ref('model_00697') }},
        {{ ref('model_00031') }}
)
select id, 'model_00851' as name from sources
