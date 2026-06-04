{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01324') }},
        {{ ref('model_01304') }}
)
select id, 'model_02225' as name from sources
