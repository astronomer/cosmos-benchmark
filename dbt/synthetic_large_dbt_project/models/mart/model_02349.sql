{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02010') }},
        {{ ref('model_01970') }}
)
select id, 'model_02349' as name from sources
