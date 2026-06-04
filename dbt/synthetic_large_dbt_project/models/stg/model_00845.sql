{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00701') }},
        {{ ref('model_00100') }},
        {{ ref('model_00233') }}
)
select id, 'model_00845' as name from sources
