{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00671') }},
        {{ ref('model_00240') }},
        {{ ref('model_00102') }}
)
select id, 'model_00965' as name from sources
