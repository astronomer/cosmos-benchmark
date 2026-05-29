{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01967') }},
        {{ ref('model_01500') }},
        {{ ref('model_01757') }}
)
select id, 'model_02360' as name from sources
