{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01673') }},
        {{ ref('model_01873') }}
)
select id, 'model_02574' as name from sources
