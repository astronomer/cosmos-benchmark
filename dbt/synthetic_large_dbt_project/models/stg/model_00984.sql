{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00361') }},
        {{ ref('model_00353') }}
)
select id, 'model_00984' as name from sources
