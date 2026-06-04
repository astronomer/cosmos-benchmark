{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00662') }},
        {{ ref('model_00073') }}
)
select id, 'model_00951' as name from sources
