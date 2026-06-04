{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01001') }},
        {{ ref('model_01142') }},
        {{ ref('model_01178') }}
)
select id, 'model_01889' as name from sources
