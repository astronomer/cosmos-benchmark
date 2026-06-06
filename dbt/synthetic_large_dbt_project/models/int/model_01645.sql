{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01010') }},
        {{ ref('model_01313') }}
)
select id, 'model_01645' as name from sources
