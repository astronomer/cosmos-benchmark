{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01605') }},
        {{ ref('model_02201') }}
)
select id, 'model_02367' as name from sources
