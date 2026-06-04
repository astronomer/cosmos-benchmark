{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00213') }},
        {{ ref('model_00283') }},
        {{ ref('model_00054') }}
)
select id, 'model_01298' as name from sources
