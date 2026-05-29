{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00368') }},
        {{ ref('model_00693') }}
)
select id, 'model_00894' as name from sources
