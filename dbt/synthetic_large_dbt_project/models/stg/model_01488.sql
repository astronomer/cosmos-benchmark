{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00701') }},
        {{ ref('model_00617') }}
)
select id, 'model_01488' as name from sources
