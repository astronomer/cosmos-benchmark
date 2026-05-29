{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02163') }},
        {{ ref('model_01673') }}
)
select id, 'model_02346' as name from sources
