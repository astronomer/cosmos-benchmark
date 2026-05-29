{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01014') }},
        {{ ref('model_00997') }},
        {{ ref('model_01061') }}
)
select id, 'model_01543' as name from sources
