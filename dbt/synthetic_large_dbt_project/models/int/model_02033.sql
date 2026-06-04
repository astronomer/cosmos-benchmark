{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01252') }},
        {{ ref('model_01109') }}
)
select id, 'model_02033' as name from sources
