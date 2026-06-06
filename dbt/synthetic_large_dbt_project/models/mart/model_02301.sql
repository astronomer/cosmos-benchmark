{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01581') }},
        {{ ref('model_01943') }},
        {{ ref('model_01619') }}
)
select id, 'model_02301' as name from sources
