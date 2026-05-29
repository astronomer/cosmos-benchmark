{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02146') }},
        {{ ref('model_02180') }}
)
select id, 'model_02791' as name from sources
