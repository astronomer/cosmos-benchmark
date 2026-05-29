{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00346') }},
        {{ ref('model_00640') }},
        {{ ref('model_00061') }}
)
select id, 'model_01084' as name from sources
