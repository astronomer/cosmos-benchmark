{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00828') }},
        {{ ref('model_00752') }},
        {{ ref('model_00902') }}
)
select id, 'model_01885' as name from sources
