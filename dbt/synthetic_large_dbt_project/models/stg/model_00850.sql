{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00721') }},
        {{ ref('model_00203') }}
)
select id, 'model_00850' as name from sources
