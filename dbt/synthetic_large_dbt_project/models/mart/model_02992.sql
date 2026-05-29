{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02096') }},
        {{ ref('model_01669') }}
)
select id, 'model_02992' as name from sources
