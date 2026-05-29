{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01466') }},
        {{ ref('model_00841') }},
        {{ ref('model_00858') }}
)
select id, 'model_01752' as name from sources
