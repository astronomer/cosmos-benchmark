{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01524') }},
        {{ ref('model_01829') }}
)
select id, 'model_02374' as name from sources
