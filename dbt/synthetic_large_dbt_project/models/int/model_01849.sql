{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01420') }},
        {{ ref('model_00945') }},
        {{ ref('model_00947') }}
)
select id, 'model_01849' as name from sources
