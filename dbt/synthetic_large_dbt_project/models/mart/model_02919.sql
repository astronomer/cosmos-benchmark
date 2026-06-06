{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01593') }},
        {{ ref('model_02095') }}
)
select id, 'model_02919' as name from sources
