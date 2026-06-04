{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00951') }},
        {{ ref('model_01441') }}
)
select id, 'model_01651' as name from sources
