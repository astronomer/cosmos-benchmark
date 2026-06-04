{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00114') }},
        {{ ref('model_00618') }},
        {{ ref('model_00178') }}
)
select id, 'model_01248' as name from sources
