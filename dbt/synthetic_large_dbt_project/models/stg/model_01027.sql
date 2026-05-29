{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00077') }},
        {{ ref('model_00567') }}
)
select id, 'model_01027' as name from sources
