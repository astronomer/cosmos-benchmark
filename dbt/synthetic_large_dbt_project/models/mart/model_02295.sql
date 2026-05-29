{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01832') }},
        {{ ref('model_01804') }}
)
select id, 'model_02295' as name from sources
