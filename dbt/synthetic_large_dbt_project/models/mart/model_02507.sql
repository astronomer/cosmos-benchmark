{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01671') }},
        {{ ref('model_01602') }},
        {{ ref('model_02009') }}
)
select id, 'model_02507' as name from sources
