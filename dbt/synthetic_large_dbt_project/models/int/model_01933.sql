{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01247') }},
        {{ ref('model_00967') }},
        {{ ref('model_01469') }}
)
select id, 'model_01933' as name from sources
