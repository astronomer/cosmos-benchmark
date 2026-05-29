{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01112') }},
        {{ ref('model_00880') }}
)
select id, 'model_02155' as name from sources
