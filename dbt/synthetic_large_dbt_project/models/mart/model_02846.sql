{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02242') }},
        {{ ref('model_01518') }}
)
select id, 'model_02846' as name from sources
