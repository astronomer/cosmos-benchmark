{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00215') }},
        {{ ref('model_00429') }}
)
select id, 'model_01038' as name from sources
