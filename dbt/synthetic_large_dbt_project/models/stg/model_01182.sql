{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00508') }},
        {{ ref('model_00532') }},
        {{ ref('model_00746') }}
)
select id, 'model_01182' as name from sources
