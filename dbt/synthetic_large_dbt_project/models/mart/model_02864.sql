{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02173') }},
        {{ ref('model_01804') }},
        {{ ref('model_01602') }}
)
select id, 'model_02864' as name from sources
