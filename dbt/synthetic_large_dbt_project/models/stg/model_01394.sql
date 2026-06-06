{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00410') }},
        {{ ref('model_00711') }}
)
select id, 'model_01394' as name from sources
