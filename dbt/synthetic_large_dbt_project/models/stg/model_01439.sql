{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00418') }},
        {{ ref('model_00260') }}
)
select id, 'model_01439' as name from sources
