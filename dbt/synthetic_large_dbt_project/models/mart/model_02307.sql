{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01794') }},
        {{ ref('model_02245') }},
        {{ ref('model_02229') }}
)
select id, 'model_02307' as name from sources
