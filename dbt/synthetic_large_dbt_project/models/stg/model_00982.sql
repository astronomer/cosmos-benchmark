{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00592') }},
        {{ ref('model_00557') }}
)
select id, 'model_00982' as name from sources
