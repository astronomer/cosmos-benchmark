{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00040') }},
        {{ ref('model_00571') }},
        {{ ref('model_00396') }}
)
select id, 'model_01157' as name from sources
