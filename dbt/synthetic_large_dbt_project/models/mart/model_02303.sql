{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01781') }},
        {{ ref('model_02205') }}
)
select id, 'model_02303' as name from sources
