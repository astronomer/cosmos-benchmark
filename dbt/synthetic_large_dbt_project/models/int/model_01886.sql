{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00818') }},
        {{ ref('model_00865') }}
)
select id, 'model_01886' as name from sources
