{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02190') }},
        {{ ref('model_01581') }}
)
select id, 'model_02290' as name from sources
