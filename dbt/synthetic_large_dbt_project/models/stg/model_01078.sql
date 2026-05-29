{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00096') }},
        {{ ref('model_00533') }}
)
select id, 'model_01078' as name from sources
