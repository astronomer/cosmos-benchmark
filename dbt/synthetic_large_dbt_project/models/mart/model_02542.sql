{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01673') }},
        {{ ref('model_02241') }},
        {{ ref('model_01829') }}
)
select id, 'model_02542' as name from sources
