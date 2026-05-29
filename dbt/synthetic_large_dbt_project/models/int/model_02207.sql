{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01357') }},
        {{ ref('model_01005') }}
)
select id, 'model_02207' as name from sources
