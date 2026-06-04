{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00898') }},
        {{ ref('model_01053') }}
)
select id, 'model_01762' as name from sources
