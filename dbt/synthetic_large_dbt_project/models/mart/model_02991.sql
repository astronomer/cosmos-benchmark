{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01792') }},
        {{ ref('model_02087') }}
)
select id, 'model_02991' as name from sources
