{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01986') }},
        {{ ref('model_01846') }}
)
select id, 'model_02564' as name from sources
