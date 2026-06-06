{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01265') }},
        {{ ref('model_00965') }},
        {{ ref('model_01107') }}
)
select id, 'model_02074' as name from sources
