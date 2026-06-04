{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02154') }},
        {{ ref('model_01855') }},
        {{ ref('model_01916') }}
)
select id, 'model_02667' as name from sources
