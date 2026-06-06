{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00532') }},
        {{ ref('model_00469') }}
)
select id, 'model_00838' as name from sources
