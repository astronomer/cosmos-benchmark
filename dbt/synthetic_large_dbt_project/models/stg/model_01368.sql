{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00323') }},
        {{ ref('model_00701') }}
)
select id, 'model_01368' as name from sources
