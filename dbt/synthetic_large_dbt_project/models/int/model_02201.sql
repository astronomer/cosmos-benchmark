{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01030') }},
        {{ ref('model_01219') }}
)
select id, 'model_02201' as name from sources
