{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00277') }},
        {{ ref('model_00678') }},
        {{ ref('model_00675') }}
)
select id, 'model_01133' as name from sources
