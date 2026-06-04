{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00839') }},
        {{ ref('model_00858') }}
)
select id, 'model_01848' as name from sources
