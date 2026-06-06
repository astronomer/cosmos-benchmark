{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00568') }},
        {{ ref('model_00099') }}
)
select id, 'model_01221' as name from sources
