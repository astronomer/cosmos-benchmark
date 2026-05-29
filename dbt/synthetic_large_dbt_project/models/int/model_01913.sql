{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00882') }},
        {{ ref('model_01469') }}
)
select id, 'model_01913' as name from sources
