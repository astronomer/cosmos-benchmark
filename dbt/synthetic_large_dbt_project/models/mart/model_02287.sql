{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01511') }},
        {{ ref('model_01997') }}
)
select id, 'model_02287' as name from sources
