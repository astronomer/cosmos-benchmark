{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00580') }},
        {{ ref('model_00373') }},
        {{ ref('model_00323') }}
)
select id, 'model_00967' as name from sources
