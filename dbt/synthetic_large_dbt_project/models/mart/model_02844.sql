{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01976') }},
        {{ ref('model_02023') }},
        {{ ref('model_01625') }}
)
select id, 'model_02844' as name from sources
