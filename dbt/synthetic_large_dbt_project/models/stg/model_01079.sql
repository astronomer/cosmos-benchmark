{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00162') }},
        {{ ref('model_00644') }}
)
select id, 'model_01079' as name from sources
