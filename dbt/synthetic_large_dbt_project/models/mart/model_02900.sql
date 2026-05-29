{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01574') }},
        {{ ref('model_01605') }},
        {{ ref('model_02197') }}
)
select id, 'model_02900' as name from sources
