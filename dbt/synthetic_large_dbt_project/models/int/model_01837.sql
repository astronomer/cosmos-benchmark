{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00855') }},
        {{ ref('model_01467') }},
        {{ ref('model_01497') }}
)
select id, 'model_01837' as name from sources
