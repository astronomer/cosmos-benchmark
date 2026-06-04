{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00566') }},
        {{ ref('model_00168') }}
)
select id, 'model_01290' as name from sources
