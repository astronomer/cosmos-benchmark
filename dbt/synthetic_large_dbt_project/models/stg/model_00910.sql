{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00422') }},
        {{ ref('model_00036') }}
)
select id, 'model_00910' as name from sources
