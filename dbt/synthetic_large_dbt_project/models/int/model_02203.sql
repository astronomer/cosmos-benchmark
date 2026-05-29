{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01244') }},
        {{ ref('model_01041') }}
)
select id, 'model_02203' as name from sources
