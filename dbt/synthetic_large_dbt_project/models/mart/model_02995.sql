{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01874') }},
        {{ ref('model_02093') }},
        {{ ref('model_01893') }}
)
select id, 'model_02995' as name from sources
