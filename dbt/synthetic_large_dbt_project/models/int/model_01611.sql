{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00806') }},
        {{ ref('model_01058') }}
)
select id, 'model_01611' as name from sources
