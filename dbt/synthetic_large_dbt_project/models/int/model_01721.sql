{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00789') }},
        {{ ref('model_00877') }}
)
select id, 'model_01721' as name from sources
