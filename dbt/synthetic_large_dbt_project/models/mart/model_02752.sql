{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02043') }},
        {{ ref('model_01700') }},
        {{ ref('model_01537') }}
)
select id, 'model_02752' as name from sources
