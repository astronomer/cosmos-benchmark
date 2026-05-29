{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01614') }},
        {{ ref('model_02239') }},
        {{ ref('model_01673') }}
)
select id, 'model_02335' as name from sources
