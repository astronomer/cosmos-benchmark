{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00561') }},
        {{ ref('model_00055') }}
)
select id, 'model_01055' as name from sources
