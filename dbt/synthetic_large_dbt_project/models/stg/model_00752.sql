{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00653') }},
        {{ ref('model_00608') }}
)
select id, 'model_00752' as name from sources
