{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02003') }},
        {{ ref('model_01532') }},
        {{ ref('model_02011') }}
)
select id, 'model_02683' as name from sources
