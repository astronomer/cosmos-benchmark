{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00077') }},
        {{ ref('model_00654') }},
        {{ ref('model_00464') }}
)
select id, 'model_01265' as name from sources
