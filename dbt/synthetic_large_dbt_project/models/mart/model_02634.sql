{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02058') }},
        {{ ref('model_01563') }}
)
select id, 'model_02634' as name from sources
