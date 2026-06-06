{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00710') }},
        {{ ref('model_00701') }},
        {{ ref('model_00278') }}
)
select id, 'model_01068' as name from sources
